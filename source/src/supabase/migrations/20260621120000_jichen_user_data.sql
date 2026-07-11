-- 吉辰万年历：用户提醒/纪念日云端同步（SPEC-021 / LOOP-006）

CREATE TABLE IF NOT EXISTS public.jichen_user_data (
    user_id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    backup_json JSONB NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS jichen_user_data_updated_at_idx
    ON public.jichen_user_data (updated_at DESC);

ALTER TABLE public.jichen_user_data ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "jichen_user_data_select_own" ON public.jichen_user_data;
DROP POLICY IF EXISTS "jichen_user_data_insert_own" ON public.jichen_user_data;
DROP POLICY IF EXISTS "jichen_user_data_update_own" ON public.jichen_user_data;
DROP POLICY IF EXISTS "jichen_user_data_delete_own" ON public.jichen_user_data;

CREATE POLICY "jichen_user_data_select_own"
    ON public.jichen_user_data FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "jichen_user_data_insert_own"
    ON public.jichen_user_data FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "jichen_user_data_update_own"
    ON public.jichen_user_data FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "jichen_user_data_delete_own"
    ON public.jichen_user_data FOR DELETE
    USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.touch_jichen_user_data_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS jichen_user_data_modtime ON public.jichen_user_data;
CREATE TRIGGER jichen_user_data_modtime
  BEFORE UPDATE ON public.jichen_user_data
  FOR EACH ROW
  EXECUTE FUNCTION public.touch_jichen_user_data_updated_at();
