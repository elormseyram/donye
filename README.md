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
`final-backend1/002_unique_bike_assignment.sql`, then start the API:

```powershell
cd final-backend1
npm.cmd install
npm.cmd start
```

Android emulators use `http://10.0.2.2:3000` by default. For a physical device
or deployed backend, pass a reachable URL:

```powershell
flutter run --dart-define=BACKEND_BASE_URL=https://api.example.com
```
