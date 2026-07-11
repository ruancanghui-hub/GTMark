-- 吉辰万年历: events per authenticated user

CREATE TABLE IF NOT EXISTS public.events (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    date TIMESTAMPTZ NOT NULL,
    category TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('countdown', 'countup')),
    color TEXT,
    is_pinned BOOLEAN DEFAULT FALSE,
    background_image TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS events_user_id_created_at_idx ON public.events (user_id, created_at DESC);

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "events_select_own" ON public.events;
DROP POLICY IF EXISTS "events_insert_own" ON public.events;
DROP POLICY IF EXISTS "events_update_own" ON public.events;
DROP POLICY IF EXISTS "events_delete_own" ON public.events;

CREATE POLICY "events_select_own" ON public.events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "events_insert_own" ON public.events FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "events_update_own" ON public.events FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "events_delete_own" ON public.events FOR DELETE USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.update_events_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_events_modtime ON public.events;
CREATE TRIGGER update_events_modtime
  BEFORE UPDATE ON public.events
  FOR EACH ROW
  EXECUTE FUNCTION public.update_events_updated_at();
