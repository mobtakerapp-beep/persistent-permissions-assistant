CREATE OR REPLACE FUNCTION public.ensure_fixed_admin_trg()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  target_user_id uuid;
BEGIN
  IF TG_TABLE_NAME = 'profiles' THEN
    target_user_id := NEW.id;
  ELSIF TG_TABLE_NAME = 'subscriptions' THEN
    target_user_id := NEW.user_id;
  ELSE
    RETURN NEW;
  END IF;

  PERFORM public.ensure_fixed_admin(target_user_id);
  RETURN NEW;
END;
$$;