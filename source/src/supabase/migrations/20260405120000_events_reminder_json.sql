ALTER TABLE public.events
  ADD COLUMN IF NOT EXISTS reminder_json JSONB;
