// Deploy: `supabase functions deploy resolve_link --no-verify-jwt`
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

type Body = { url?: string };

const MOBILE_UA =
  "Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0 Mobile Safari/537.36";

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders() });
  }
  try {
    const body = (await req.json().catch(() => ({}))) as Body;
    const url = body.url?.trim();
    if (!url || !/^https?:\/\//i.test(url)) {
      return json({ error: "invalid_url" }, 400);
    }

    const html = await fetchHtmlWithKuaishouFallback(url);
    const parsed = parseHtmlMetadata(html.body, html.finalUrl);

    if (!parsed.title && !parsed.coverUrl) {
      return json({ error: "no_metadata" }, 422);
    }

    const title = parsed.title ? clean(parsed.title) : fallbackTitle(url);
    const confidence = computeConfidence({
      title,
      description: parsed.description,
      coverUrl: parsed.coverUrl,
      url: html.finalUrl,
      source: parsed.source,
    });

    return json({
      title,
      description: parsed.description ? clean(parsed.description) : null,
      coverUrl: parsed.coverUrl ?? null,
      confidence,
      source: parsed.source,
      needsReview: confidence < 0.55 || isLowQualityTitle(title, html.finalUrl),
    });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

async function fetchHtmlWithKuaishouFallback(
  url: string,
): Promise<{ body: string; finalUrl: string }> {
  const first = await fetchHtml(url, true);
  let body = first.body;
  const finalUrl = first.finalUrl;

  if (!isKuaishouUrl(url) && !isKuaishouUrl(finalUrl)) {
    return { body, finalUrl };
  }

  const full = await fetchHtml(finalUrl, true);
  if (full.body.length >= body.length) {
    body = full.body;
  }

  if (isIncompleteKuaishouHtml(body)) {
    for (const range of ["bytes=100000-", "bytes=80000-"]) {
      const tail = await fetchHtmlRange(finalUrl, range);
      if (!tail) continue;
      if (!isIncompleteKuaishouHtml(tail)) {
        return { body: tail, finalUrl };
      }
      const overlapEnd = Math.min(body.length, 80000);
      const merged = `${body.substring(0, overlapEnd)}${tail}`;
      if (!isIncompleteKuaishouHtml(merged)) {
        return { body: merged, finalUrl };
      }
      if (merged.length > body.length) body = merged;
    }
  }

  return { body, finalUrl };
}

async function fetchHtml(
  url: string,
  identityOnly = false,
): Promise<{ body: string; finalUrl: string }> {
  const headers: Record<string, string> = {
    "User-Agent": MOBILE_UA,
    Accept: "text/html,application/xhtml+xml",
    "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
    ...requestHeadersFor(url),
  };
  if (identityOnly) headers["Accept-Encoding"] = "identity";

  const res = await fetch(url, { redirect: "follow", headers });
  if (!res.ok) {
    throw new Error(`fetch_failed:${res.status}`);
  }
  const body = await res.text();
  return { body, finalUrl: res.url || url };
}

async function fetchHtmlRange(
  url: string,
  range: string,
): Promise<string | null> {
  try {
    const res = await fetch(url, {
      redirect: "follow",
      headers: {
        "User-Agent": MOBILE_UA,
        Accept: "text/html,application/xhtml+xml",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        Range: range,
        "Accept-Encoding": "identity",
        ...requestHeadersFor(url),
      },
    });
    if (!res.ok) return null;
    return await res.text();
  } catch {
    return null;
  }
}

function hasKuaishouMetadata(body: string): boolean {
  if (body.includes("window.INIT_STATE")) return true;
  if (/"photo"\s*:\s*\{/.test(body) &&
    (body.includes('"userName"') || body.includes('"caption"'))) {
    return true;
  }
  if (body.includes("singlePicture") &&
    body.includes('"caption"') &&
    body.includes('"userName"')) {
    return true;
  }
  return false;
}

function isIncompleteKuaishouHtml(body: string): boolean {
  if (body.length < 50000) return true;
  return !hasKuaishouMetadata(body);
}

type ParseResult = {
  title: string | null;
  description: string | null;
  coverUrl: string | null;
  source: string;
};

function parseHtmlMetadata(html: string, url: string): ParseResult {
  const ks = isKuaishouUrl(url) ? extractKuaishouFromBody(html) : null;

  let title =
    meta(html, "og:title") ??
    meta(html, "twitter:title") ??
    titleTag(html);
  if (isLowQualityTitle(title, url)) title = null;
  title = title ?? ks?.title ?? null;

  const description =
    meta(html, "og:description") ??
    meta(html, "twitter:description") ??
    meta(html, "description") ??
    ks?.description ??
    null;

  const coverRaw = meta(html, "og:image") ?? meta(html, "twitter:image");
  let coverUrl = absolutizeImageUrl(coverRaw, url);
  if (!isValidKuaishouCover(coverUrl)) coverUrl = null;
  coverUrl = coverUrl ?? ks?.coverUrl ?? extractEmbeddedCover(html);
  if (!isValidKuaishouCover(coverUrl)) coverUrl = null;

  const ogTitle = meta(html, "og:title") ?? meta(html, "twitter:title");
  const usedOg = ogTitle != null && !isLowQualityTitle(ogTitle, url) &&
    title === clean(ogTitle);
  const source = ks?.source ??
    (usedOg ? "og" : (ks ? "kuaishou_json" : "og"));

  return { title, description, coverUrl, source };
}

function extractKuaishouFromBody(
  body: string,
): { title: string | null; description: string | null; coverUrl: string | null; source: string } | null {
  const fromInit = extractKuaishouFromInitState(body);
  if (fromInit && (fromInit.title || fromInit.coverUrl)) {
    return { ...fromInit, source: "init_state" };
  }

  const fromJson = extractKuaishouFromJson(body);
  const fromDom = extractKuaishouFromDomRegex(body);
  const fromGlobal = extractKuaishouFromGlobalRegex(body);
  const merged = mergeKs(fromJson, mergeKs(fromDom, fromGlobal));
  if (merged && (merged.title || merged.coverUrl)) {
    return {
      title: merged.title,
      description: merged.description,
      coverUrl: merged.coverUrl,
      source: fromJson ? "kuaishou_json" : "kuaishou_dom",
    };
  }
  return null;
}

function mergeKs(
  a: { title: string | null; description: string | null; coverUrl: string | null } | null,
  b: { title: string | null; description: string | null; coverUrl: string | null } | null,
) {
  if (!a) return b;
  if (!b) return a;
  return {
    title: a.title ?? b.title,
    description: a.description ?? b.description,
    coverUrl: a.coverUrl ?? b.coverUrl,
  };
}

function parseInitState(body: string): Record<string, unknown> | null {
  const marker = "window.INIT_STATE = ";
  const start = body.indexOf(marker);
  if (start < 0) return null;
  const jsonStart = start + marker.length;
  const scriptEnd = body.indexOf("</script>", jsonStart);
  if (scriptEnd <= jsonStart) return null;
  try {
    return JSON.parse(body.substring(jsonStart, scriptEnd)) as Record<string, unknown>;
  } catch {
    return null;
  }
}

function findPhotoNode(node: unknown, depth = 0): Record<string, unknown> | null {
  if (depth > 8) return null;
  if (node && typeof node === "object" && !Array.isArray(node)) {
    const map = node as Record<string, unknown>;
    const photo = map.photo;
    if (photo && typeof photo === "object" && !Array.isArray(photo)) {
      const p = photo as Record<string, unknown>;
      if ("caption" in p || "userName" in p) return p;
    }
    for (const value of Object.values(map)) {
      const found = findPhotoNode(value, depth + 1);
      if (found) return found;
    }
  } else if (Array.isArray(node)) {
    for (const item of node) {
      const found = findPhotoNode(item, depth + 1);
      if (found) return found;
    }
  }
  return null;
}

function coverFromPhotoMap(photo: Record<string, unknown>): string | null {
  const coverUrls = photo.coverUrls;
  if (Array.isArray(coverUrls)) {
    for (const item of coverUrls) {
      if (item && typeof item === "object") {
        const url = (item as Record<string, unknown>).url?.toString();
        if (isValidKuaishouCover(url ?? null)) return decodeEntities(url!);
      }
    }
  }
  for (const key of ["headUrl", "headurl"]) {
    const url = photo[key]?.toString();
    if (isValidKuaishouCover(url ?? null)) return decodeEntities(url!);
  }
  return null;
}

function extractKuaishouFromInitState(
  body: string,
): { title: string | null; description: string | null; coverUrl: string | null } | null {
  const state = parseInitState(body);
  if (!state) return null;
  const photo = findPhotoNode(state);
  if (!photo) return null;

  const caption = photo.caption?.toString();
  const userName = photo.userName?.toString();
  const titled = kuaishouTitleFromFields(body, caption, userName);
  const cover = coverFromPhotoMap(photo) ?? extractEmbeddedCover(body);
  if (!titled.title && !cover) return null;
  return { title: titled.title, description: titled.description, coverUrl: cover };
}

function kuaishouTitleFromFields(
  body: string,
  caption?: string,
  userName?: string,
): { title: string | null; description: string | null } {
  let title: string | null = null;
  let description: string | null = null;
  if (isMeaningfulCaption(caption)) {
    title = caption ?? null;
    if (userName) description = userName.startsWith("@") ? userName : `@${userName}`;
  } else if (userName) {
    title = userName.startsWith("@") ? userName : `@${userName}`;
  } else {
    const shareUser = body.match(/"shareTitle"\s*:\s*"分享了@([^"\s]+)/)?.[1];
    if (shareUser) title = `@${shareUser}`;
  }
  return { title, description };
}

function extractKuaishouFromGlobalRegex(
  body: string,
): { title: string | null; description: string | null; coverUrl: string | null } | null {
  if (!body.includes("singlePicture") && !body.includes("window.INIT_STATE")) {
    return null;
  }
  const captions = allMatches(body, /"caption"\s*:\s*"([^"]*)"/g);
  const users = allMatches(body, /"userName"\s*:\s*"([^"]+)"/g);
  const caption = captions.length ? captions[captions.length - 1] : undefined;
  const userName = users.length ? users[users.length - 1] : undefined;
  const titled = kuaishouTitleFromFields(body, caption, userName);
  const coverCandidates = [
    ...allMatches(
      body,
      /"coverUrls"\s*:\s*\[[^\]]*"url"\s*:\s*"(https:\/\/[^"]*yximgs\.com\/upic\/[^"]+)"/g,
    ),
    extractEmbeddedCover(body),
    ...allMatches(body, /"headUrl"\s*:\s*"(https:\/\/[^"]+)"/gi),
  ];
  let cover: string | null = null;
  for (const c of coverCandidates) {
    if (isValidKuaishouCover(c)) {
      cover = c;
      break;
    }
  }
  if (!titled.title && !cover) return null;
  return { title: titled.title, description: titled.description, coverUrl: cover };
}

function computeConfidence(opts: {
  title: string | null;
  description: string | null;
  coverUrl: string | null;
  url: string;
  source: string;
}): number {
  let score = 0;
  if (opts.title && !isLowQualityTitle(opts.title, opts.url)) score += 0.45;
  else if (opts.title) score += 0.12;
  if (opts.description?.trim()) score += 0.15;
  if (opts.coverUrl?.trim()) score += 0.3;
  if (opts.source === "init_state") score += 0.08;
  else if (opts.source === "server") score += 0.06;
  else if (opts.source.startsWith("kuaishou")) score += 0.05;
  else if (opts.source === "og") score += 0.04;
  return Math.min(1, Math.max(0, score));
}

function extractKuaishouFromJson(
  body: string,
): { title: string | null; description: string | null; coverUrl: string | null } | null {
  const photoSlice = extractPhotoJsonSlice(body);
  if (
    !photoSlice &&
    !body.includes("singlePicture") &&
    !body.includes('"caption"')
  ) {
    return null;
  }
  const searchIn = photoSlice ?? body;

  const coverCandidates = [
    ...allMatches(
      searchIn,
      /"url"\s*:\s*"(https:\/\/[^"]*yximgs\.com\/upic\/[^"]+)"/gi,
    ),
    ...allMatches(
      searchIn,
      /"url"\s*:\s*"(https:\/\/[^"]*yximgs\.com\/[^"]+)"/gi,
    ),
    extractEmbeddedCover(body),
    searchIn.match(/"headurl"\s*:\s*"(https:\/\/[^"]+)"/i)?.[1],
    searchIn.match(/"headUrl"\s*:\s*"(https:\/\/[^"]+)"/i)?.[1],
  ];

  let cover: string | null = null;
  for (const candidate of coverCandidates) {
    const decoded = candidate ? decodeEntities(candidate) : null;
    if (isValidKuaishouCover(decoded)) {
      cover = decoded;
      break;
    }
  }

  const userName = searchIn.match(/"userName"\s*:\s*"([^"]+)"/)?.[1];
  const caption = searchIn.match(/"caption"\s*:\s*"([^"]*)"/)?.[1];

  let title: string | null = null;
  let description: string | null = null;
  if (isMeaningfulCaption(caption)) {
    title = caption ?? null;
    if (userName) description = userName.startsWith("@") ? userName : `@${userName}`;
  } else if (userName) {
    title = userName.startsWith("@") ? userName : `@${userName}`;
  } else {
    const shareUser = body.match(/"shareTitle"\s*:\s*"分享了@([^"\s]+)/)?.[1];
    if (shareUser) title = `@${shareUser}`;
  }

  if (!title && !cover) return null;
  return { title, description, coverUrl: cover };
}

function extractPhotoJsonSlice(body: string): string | null {
  const pattern = /"photo"\s*:\s*\{/g;
  for (const match of body.matchAll(pattern)) {
    const start = match.index ?? -1;
    if (start < 0) continue;
    const end = body.indexOf('"serialInfo"', start);
    const slice =
      end > start
        ? body.substring(start, end)
        : body.substring(start, Math.min(start + 15000, body.length));
    if (
      slice.includes('"singlePicture"') ||
      slice.includes('"userName"') ||
      slice.includes('"caption"')
    ) {
      return slice;
    }
  }
  return null;
}

function extractKuaishouFromDomRegex(
  body: string,
): { title: string | null; description: string | null; coverUrl: string | null } | null {
  const desc = body.match(/class="text txt"[^>]*>([^<]+)/i)?.[1]?.trim();
  const author = body
    .match(/class="author"[\s\S]{0,400}?class="txt"[^>]*>([^<]+)/i)?.[1]
    ?.trim();

  let title: string | null = null;
  let description: string | null = null;
  if (isMeaningfulCaption(desc)) {
    title = desc ?? null;
    if (author) description = author.startsWith("@") ? author : `@${author}`;
  } else if (author) {
    title = author.startsWith("@") ? author : `@${author}`;
  }

  const coverCandidates = [
    body.match(/<img[^>]*class="image"[^>]*src="(https:\/\/[^"]+)"/i)?.[1],
    body.match(/<img[^>]*class="avatar-image"[^>]*src="(https:\/\/[^"]+)"/i)?.[1],
    body.match(/background-image:url\((https:\/\/[^)]*yximgs\.com[^)]*)\)/i)?.[1],
  ];
  let cover: string | null = null;
  for (const candidate of coverCandidates) {
    const decoded = candidate ? decodeEntities(candidate) : null;
    if (isValidKuaishouCover(decoded)) {
      cover = decoded;
      break;
    }
  }

  if (!title && !cover) return null;
  return { title, description, coverUrl: cover };
}

function isMeaningfulCaption(caption: string | undefined): boolean {
  if (!caption || !caption.trim()) return false;
  if (caption === "...") return false;
  return caption.trim().length > 2;
}

function allMatches(body: string, pattern: RegExp): string[] {
  const out: string[] = [];
  for (const match of body.matchAll(pattern)) {
    if (match[1]) out.push(match[1]);
  }
  return out;
}

function extractEmbeddedCover(body: string): string | null {
  const jpg = body.match(
    /https?:\/\/p\d+\.a\.yximgs\.com\/upic\/[^"\s<>]+\.jpg/i,
  )?.[0];
  if (jpg) return decodeEntities(jpg);

  const any = body.match(
    /https?:\/\/[^"\s<>]*yximgs\.com\/upic\/[^"\s<>]+\.(?:jpg|jpeg|webp)/i,
  )?.[0];
  return any ? decodeEntities(any) : null;
}

function isValidKuaishouCover(url: string | null): boolean {
  if (!url || !url.trim()) return false;
  const lower = url.toLowerCase();
  if (lower.includes("admin-center")) return false;
  if (lower.includes("/udata/pkg/")) return false;
  if (lower.includes("open-in-browser")) return false;
  return (
    lower.includes("yximgs.com") ||
    lower.includes("kwimgs.com") ||
    lower.includes("kwai.net")
  );
}

function isKuaishouUrl(url: string): boolean {
  const lower = url.toLowerCase();
  return (
    lower.includes("kuaishou") ||
    lower.includes("chenzhongtech") ||
    lower.includes("gifshow")
  );
}

function isLowQualityTitle(title: string | null, url: string): boolean {
  if (!title || !title.trim()) return true;
  const trimmed = title.trim();
  const generic = new Set([
    "快手",
    "快手短视频",
    "kuaishou",
    "抖音",
    "抖音短视频",
    "小红书",
    "微博",
    "知乎",
    "bilibili",
  ]);
  if (generic.has(trimmed)) return true;
  if (trimmed === "快手内容收藏" || trimmed.endsWith("内容收藏")) {
    return trimmed.length <= 8;
  }
  return url.toLowerCase().includes("kuaishou") && trimmed === "快手";
}

function requestHeadersFor(url: string): Record<string, string> {
  const lower = url.toLowerCase();
  if (
    lower.includes("kuaishou") ||
    lower.includes("chenzhongtech") ||
    lower.includes("gifshow")
  ) {
    return { Referer: "https://www.kuaishou.com/" };
  }
  if (lower.includes("bilibili") || lower.includes("b23.tv")) {
    return { Referer: "https://www.bilibili.com/" };
  }
  if (lower.includes("xiaohongshu") || lower.includes("xhslink")) {
    return { Referer: "https://www.xiaohongshu.com/" };
  }
  return {};
}

function fallbackTitle(url: string): string {
  const lower = url.toLowerCase();
  if (lower.includes("kuaishou")) return "快手内容收藏";
  if (lower.includes("bilibili")) return "B站视频收藏";
  if (lower.includes("douyin")) return "抖音内容收藏";
  if (lower.includes("xiaohongshu") || lower.includes("xhslink")) {
    return "小红书笔记收藏";
  }
  try {
    const host = new URL(url).host.replace(/^www\./, "");
    return `网页 · ${host}`;
  } catch {
    return "链接收藏";
  }
}

function meta(html: string, key: string): string | null {
  const patterns = [
    new RegExp(
      `<meta[^>]+(?:property|name)=["']${escapeReg(key)}["'][^>]+content=["']([^"']+)["']`,
      "i",
    ),
    new RegExp(
      `<meta[^>]+content=["']([^"']+)["'][^>]+(?:property|name)=["']${escapeReg(key)}["']`,
      "i",
    ),
  ];
  for (const re of patterns) {
    const m = html.match(re);
    if (m?.[1]) return decodeEntities(m[1]);
  }
  return null;
}

function titleTag(html: string): string | null {
  const m = html.match(/<title[^>]*>([^<]+)<\/title>/i);
  return m?.[1] ? decodeEntities(m[1]) : null;
}

function clean(s: string): string {
  return s.replace(/\s+/g, " ").trim();
}

function absolutizeImageUrl(
  imageUrl: string | null,
  pageUrl: string,
): string | null {
  if (!imageUrl || !imageUrl.trim()) return null;
  const trimmed = imageUrl.trim();
  if (/^https?:\/\//i.test(trimmed)) return trimmed;
  if (trimmed.startsWith("//")) return `https:${trimmed}`;
  try {
    return new URL(trimmed, pageUrl).href;
  } catch {
    return trimmed;
  }
}

function decodeEntities(s: string): string {
  return s
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'");
}

function escapeReg(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function corsHeaders(): HeadersInit {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
  };
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders() },
  });
}
