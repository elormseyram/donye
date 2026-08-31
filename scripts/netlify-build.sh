#!/usr/bin/env bash
set -Eeuo pipefail

required_variables=(
  BACKEND_BASE_URL
  SUPABASE_URL
  SUPABASE_PUBLISHABLE_KEY
  DORNYE_PORTAL_URL
  DORNYE_PORTAL_PUBLISHABLE_KEY
)

missing_variables=()
for variable_name in "${required_variables[@]}"; do
  if [[ -z "${!variable_name:-}" ]]; then
    missing_variables+=("$variable_name")
  fi
done

if (( ${#missing_variables[@]} > 0 )); then
  echo "Missing required Netlify environment variables: ${missing_variables[*]}" >&2
  echo "Add them under Project configuration > Environment variables, then deploy again." >&2
  exit 1
fi

flutter_directory="$PWD/.netlify/flutter-sdk"
if [[ ! -x "$flutter_directory/bin/flutter" ]]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$flutter_directory"
fi

export PATH="$flutter_directory/bin:$PATH"

flutter config --enable-web
flutter pub get

dart_defines=(
  "--dart-define=BACKEND_BASE_URL=$BACKEND_BASE_URL"
  "--dart-define=SUPABASE_URL=$SUPABASE_URL"
  "--dart-define=SUPABASE_PUBLISHABLE_KEY=$SUPABASE_PUBLISHABLE_KEY"
  "--dart-define=DORNYE_PORTAL_URL=$DORNYE_PORTAL_URL"
  "--dart-define=DORNYE_PORTAL_PUBLISHABLE_KEY=$DORNYE_PORTAL_PUBLISHABLE_KEY"
)

if [[ -n "${GOOGLE_MAPS_API_KEY:-}" ]]; then
  dart_defines+=("--dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY")
fi

flutter build web --release "${dart_defines[@]}"

