// Deploy: `supabase secrets set GEMINI_API_KEY=...` then `supabase functions deploy history_of_today --no-verify-jwt`
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

type Body = { month?: number; day?: number };

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders() });
  }
  try {
    const key = Deno.env.get("GEMINI_API_KEY");
    if (!key) {
      return json({ error: "missing GEMINI_API_KEY" }, 500);
    }
    const body = (await req.json().catch(() => ({}))) as Body;
    const now = new Date();
    const month = body.month ?? now.getUTCMonth() + 1;
    const day = body.day ?? now.getUTCDate();
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December",
    ];
    const dateStr = `${monthNames[month - 1]} ${day}`;
    const prompt =
      `Provide 5 significant historical events that happened on ${dateStr} throughout history. Return ONLY a JSON array of objects with "year" (string) and "event" (string) properties.`;

    const url =
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${encodeURIComponent(key)}`;
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          responseMimeType: "application/json",
        },
      }),
    });
    if (!res.ok) {
      const t = await res.text();
      return json({ error: "gemini_error", detail: t }, 502);
    }
    const raw = await res.json();
    const text = raw?.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!text || typeof text !== "string") {
      return json([], 200);
    }
    const parsed = JSON.parse(text);
    return json(parsed, 200);
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

function corsHeaders(): HeadersInit {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  };
}

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders(), "Content-Type": "application/json" },
  });
}
