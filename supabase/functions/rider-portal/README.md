# Rider portal Edge Function

This function provides the contract consumed by the Flutter app:

- `login` authenticates a rider with Supabase Auth.
- `dashboard_refresh` returns the rider's current admin-assigned bike.
- `refresh` rotates an expired rider session.
- `logout` revokes the current session.
- `admin_save_fleet_bike` creates or updates a fleet bike.
- `admin_save_and_assign_fleet_bike` saves all bike details and assigns it to
  a rider in one admin-authorized operation.

The admin save actions accept:

```json
{
  "action": "admin_save_and_assign_fleet_bike",
  "riderId": "rider-uuid",
  "bikeId": "optional-existing-bike-uuid",
  "bikeNumber": "DNY-001",
  "model": "Dornye Cargo",
  "registrationNumber": "GR-1234-26",
  "batteryCapacityKwh": 2.4,
  "nominalVoltageV": 72,
  "motorPowerW": 3000,
  "notes": "Optional assignment note"
}
```

Only users listed in `admin_team_members` can call these actions.

It reads `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` only from the managed
Edge Function environment. Do not place either value in this directory.

Configure browser origins and deploy:

```powershell
supabase secrets set ALLOWED_ORIGINS=https://admin.example.com,https://portal.example.com
supabase functions deploy rider-portal --no-verify-jwt
```
