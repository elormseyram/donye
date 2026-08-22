# Rider portal Edge Function

This function provides the contract consumed by the Flutter app:

- `login` authenticates a rider with Supabase Auth.
- `dashboard_refresh` returns the rider's current admin-assigned bike.
- `refresh` rotates an expired rider session.
- `logout` revokes the current session.

It reads `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` only from the managed
Edge Function environment. Do not place either value in this directory.

Configure browser origins and deploy:

```powershell
supabase secrets set ALLOWED_ORIGINS=https://admin.example.com,https://portal.example.com
supabase functions deploy rider-portal --no-verify-jwt
```
