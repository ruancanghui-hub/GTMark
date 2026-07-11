import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type VerifyBody = {
  product_id?: string;
  purchase_id?: string;
  transaction_date?: string;
  source?: string;
  verification_data?: {
    local_verification_data?: string;
    server_verification_data?: string;
    source?: string;
  };
};

type AppleVerifyResponse = {
  status: number;
  environment?: string;
  receipt?: {
    in_app?: Array<{
      product_id?: string;
      transaction_id?: string;
      original_transaction_id?: string;
      purchase_date_ms?: string;
      expires_date_ms?: string;
    }>;
  };
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders() });
  }
  if (req.method !== "POST") {
    return json({ message: "method_not_allowed" }, 405);
  }

  try {
    const supabaseUrl = mustEnv("SUPABASE_URL");
    const supabaseAnonKey = mustEnv("SUPABASE_ANON_KEY");
    const serviceRoleKey = mustEnv("SUPABASE_SERVICE_ROLE_KEY");

    const authHeader = req.headers.get("Authorization") ?? "";

    const authClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const admin = createClient(supabaseUrl, serviceRoleKey);

    const {
      data: { user },
      error: userError,
    } = await authClient.auth.getUser();

    if (userError || !user) {
      return json({ message: "unauthorized" }, 401);
    }

    const body = (await req.json().catch(() => ({}))) as VerifyBody;
    const payload = body.verification_data?.server_verification_data;
    if (!payload || payload.trim().length == 0) {
      return json({ message: "missing_server_verification_data" }, 400);
    }

    const allowedProduct = Deno.env.get("IOS_VIP_PRODUCT_ID") ??
      "com.yucheng.plugindemo.vip.lifetime";

    const apple = await verifyWithApple(payload);
    if (apple.status !== 0) {
      console.warn(
        JSON.stringify({
          event: "iap_verify_failed",
          user_id: user.id,
          product_id: body.product_id ?? allowedProduct,
          purchase_id: body.purchase_id ?? null,
          apple_status: apple.status,
          reason: mapAppleStatus(apple.status),
          apple_environment: apple.environment ?? "unknown",
        }),
      );
      return json(
        {
          message: "apple_verify_failed",
          reason: mapAppleStatus(apple.status),
          apple_status: apple.status,
          environment: apple.environment,
        },
        400,
      );
    }

    const purchases = apple.receipt?.in_app ?? [];
    const matched = purchases.find((p) => {
      const productMatch = (p.product_id ?? body.product_id) === allowedProduct;
      if (!productMatch) return false;
      if (body.purchase_id && p.transaction_id) {
        return p.transaction_id === body.purchase_id;
      }
      return true;
    });

    if (!matched) {
      return json({ message: "product_not_found_in_receipt" }, 400);
    }

    const purchasedAt = msToIso(matched.purchase_date_ms) ??
      msToIso(body.transaction_date) ??
      new Date().toISOString();
    const expiresAt = msToIso(matched.expires_date_ms);

    const transactionId = matched.transaction_id ?? body.purchase_id;
    if (!transactionId) {
      return json({ message: "missing_transaction_id" }, 400);
    }

    const originalTransactionId = matched.original_transaction_id ?? transactionId;

    const receiptPayload = {
      apple_response_status: apple.status,
      apple_environment: apple.environment,
      source: body.source,
      verification_source: body.verification_data?.source,
    };
    console.log(
      JSON.stringify({
        event: "iap_verify_success",
        user_id: user.id,
        product_id: allowedProduct,
        purchase_id: body.purchase_id ?? null,
        transaction_id: transactionId,
        original_transaction_id: originalTransactionId,
        apple_status: apple.status,
        apple_environment: apple.environment ?? "unknown",
      }),
    );

    const { error: receiptErr } = await admin.from("iap_receipts").upsert(
      {
        user_id: user.id,
        platform: "ios",
        product_id: allowedProduct,
        transaction_id: transactionId,
        original_transaction_id: originalTransactionId,
        environment: apple.environment,
        purchased_at: purchasedAt,
        expires_at: expiresAt,
        status: "active",
        receipt_payload: receiptPayload,
      },
      {
        onConflict: "transaction_id",
      },
    );

    if (receiptErr) {
      return json({ message: "save_receipt_failed", detail: receiptErr.message }, 500);
    }

    const { error: entitlementErr } = await admin.from("user_entitlements").upsert(
      {
        user_id: user.id,
        is_vip: true,
        vip_product_id: allowedProduct,
        vip_granted_at: purchasedAt,
        source: "ios_iap_verify",
      },
      {
        onConflict: "user_id",
      },
    );

    if (entitlementErr) {
      return json(
        { message: "save_entitlement_failed", detail: entitlementErr.message },
        500,
      );
    }

    return json({
      is_vip: true,
      vip_product_id: allowedProduct,
      vip_granted_at: purchasedAt,
      environment: apple.environment,
    });
  } catch (e) {
    return json({ message: String(e) }, 500);
  }
});

async function verifyWithApple(receiptDataBase64: string): Promise<AppleVerifyResponse> {
  const password = Deno.env.get("APPLE_SHARED_SECRET") ?? "";
  const body = {
    "receipt-data": receiptDataBase64,
    password,
    "exclude-old-transactions": true,
  };

  const prod = await fetch("https://buy.itunes.apple.com/verifyReceipt", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const prodJson = (await prod.json()) as AppleVerifyResponse;
  if (prodJson.status === 21007) {
    const sandbox = await fetch("https://sandbox.itunes.apple.com/verifyReceipt", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    return (await sandbox.json()) as AppleVerifyResponse;
  }
  return prodJson;
}

function mustEnv(name: string): string {
  const value = Deno.env.get(name);
  if (!value || value.length === 0) {
    throw new Error(`missing env: ${name}`);
  }
  return value;
}

function msToIso(input?: string): string | null {
  if (!input || input.length == 0) return null;
  const parsed = Number(input);
  if (Number.isFinite(parsed) && parsed > 0) {
    return new Date(parsed).toISOString();
  }
  const ts = Date.parse(input);
  if (!Number.isNaN(ts)) return new Date(ts).toISOString();
  return null;
}

function corsHeaders(): HeadersInit {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  };
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders(), "Content-Type": "application/json" },
  });
}

function mapAppleStatus(status: number): string {
  switch (status) {
    case 21000:
      return "bad_json_payload";
    case 21002:
      return "invalid_receipt_data";
    case 21003:
      return "receipt_authentication_failed";
    case 21004:
      return "shared_secret_mismatch";
    case 21005:
      return "apple_unavailable";
    case 21006:
      return "subscription_expired";
    case 21007:
      return "sandbox_receipt_sent_to_production";
    case 21008:
      return "production_receipt_sent_to_sandbox";
    case 21010:
      return "receipt_not_found_or_revoked";
    default:
      return `unknown_status_${status}`;
  }
}
