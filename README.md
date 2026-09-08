# donye

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Donye admin backend connection

The Flutter rider app and `final-backend1` share the same Supabase project.
Signup goes through the backend so bike ownership is validated before the app
imports the returned Supabase session.

Apply `final-backend1/001_donye_schema.sql`, followed by
`final-backend1/002_unique_bike_assignment.sql` and
`final-backend1/003_security_hardening.sql`, then start the API:

```powershell
cd final-backend1
npm.cmd install
npm.cmd start
```

Copy `config/example.json` to `config/local.json`, fill in local values, and
never commit that file. Run Flutter with:

```powershell
flutter run --dart-define-from-file=config/local.json
```

For production, use an HTTPS backend URL and your deployment secret manager.
The Supabase publishable key is intentionally a client key; access is enforced
by the RLS policies. Never put a service-role or secret key in Flutter.

The live telemetry connection also requires `MQTT_BROKER_HOST`,
`MQTT_USERNAME`, and `MQTT_PASSWORD`. Add all three to `config/local.json` for
local runs and to the Netlify project's environment variables for web deploys.
The web app connects to HiveMQ over secure WebSockets on port 8884; native apps
use MQTT over TLS on port 8883.

For hardware whose MQTT identifier differs from its database bike ID, set the
optional `MQTT_BIKE_ID` value (for example, `dev-001`). This changes only MQTT
topic routing and leaves database assignments and history intact.

For a deployed backend, pass a reachable URL in the configuration file or with:

```powershell
flutter run --dart-define=BACKEND_BASE_URL=https://api.example.com
```

## Dornye rider portal function

The admin-side Edge Function consumed by Flutter is located at
`supabase/functions/rider-portal`. It authenticates riders, refreshes sessions,
and returns the current `riders.assigned_bike_id` with the matching bike.

Configure exact browser origins and deploy from this workspace:

```powershell
supabase secrets set ALLOWED_ORIGINS=https://admin.example.com,https://portal.example.com
supabase functions deploy rider-portal --no-verify-jwt
```

Supabase automatically provides the function's URL and service-role secret at
runtime. Do not add either credential to source control.
