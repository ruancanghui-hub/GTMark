-- 吉辰万年历: event importance (hard deadline emphasis)
ALTER TABLE public.events
  ADD COLUMN IF NOT EXISTS importance TEXT NOT NULL DEFAULT 'normal';

COMMENT ON COLUMN public.events.importance IS 'normal | hardDeadline';
