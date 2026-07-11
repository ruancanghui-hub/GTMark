-- iOS IAP: one-time VIP entitlement + receipt log

CREATE TABLE IF NOT EXISTS public.iap_receipts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    platform TEXT NOT NULL DEFAULT 'ios',
    product_id TEXT NOT NULL,
    transaction_id TEXT NOT NULL UNIQUE,
    original_transaction_id TEXT,
    environment TEXT,
    purchased_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    status TEXT NOT NULL DEFAULT 'active',
    receipt_payload JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS iap_receipts_user_id_idx ON public.iap_receipts (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS iap_receipts_original_transaction_id_idx ON public.iap_receipts (original_transaction_id);

CREATE TABLE IF NOT EXISTS public.user_entitlements (
    user_id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    is_vip BOOLEAN NOT NULL DEFAULT FALSE,
    vip_product_id TEXT,
    vip_granted_at TIMESTAMPTZ,
    source TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_iap_receipts_updated_at ON public.iap_receipts;
CREATE TRIGGER update_iap_receipts_updated_at
  BEFORE UPDATE ON public.iap_receipts
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_entitlements_updated_at ON public.user_entitlements;
CREATE TRIGGER update_user_entitlements_updated_at
  BEFORE UPDATE ON public.user_entitlements
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

ALTER TABLE public.iap_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_entitlements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "entitlements_select_own"
ON public.user_entitlements
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "iap_receipts_select_own"
ON public.iap_receipts
FOR SELECT
USING (auth.uid() = user_id);
