# Donye — Express Backend

Node.js/Express backend for the **SheRides** Flutter app.  
Built directly from the Flutter source — every route, field name, and enum  
matches the Dart models exactly.

---

## Setup

```bash
npm install
cp .env.example .env        # fill in your Supabase keys
# Paste migrations/001_donye_schema.sql into the Supabase SQL editor
npm run dev
```

---

## API Routes

All routes (except `/health` and `/api/v1/auth/*`) require:
```
Authorization: Bearer <supabase_access_token>
```
This is the token Flutter's `_AuthInterceptor` already attaches automatically.

### Auth
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| POST | `/api/v1/auth/login` | `AuthRemoteDataSource.login()` |
| POST | `/api/v1/auth/signup` | `AuthRemoteDataSource.signup()` |
| POST | `/api/v1/auth/logout` | `AuthRemoteDataSource.logout()` |
| POST | `/api/v1/auth/forgot-password` | `AuthRemoteDataSource.forgotPassword()` |
| GET  | `/api/v1/auth/me` | `AuthRemoteDataSource.getCurrentRider()` |
| POST | `/api/v1/auth/refresh` | Token refresh |

### Profile
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET   | `/api/v1/profile/bike?bikeId=` | `ProfileRemoteDataSource.getBike()` |
| PATCH | `/api/v1/profile` | `ProfileRemoteDataSource.updateRider()` |

### Telemetry  (`telemetry_logs` table)
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET  | `/api/v1/telemetry/history?bikeId=&limit=` | `TelemetryRemoteDataSource.getHistory()` |
| GET  | `/api/v1/telemetry/latest?bikeId=` | Dashboard latest snapshot |
| POST | `/api/v1/telemetry` | IoT device push |
| POST | `/api/v1/telemetry/batch` | Offline buffer flush |

### Alerts  (`alerts` table)
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET   | `/api/v1/alerts?bikeId=` | `AlertsRemoteDataSource.streamActiveAlerts()` (HTTP fallback) |
| POST  | `/api/v1/alerts` | IoT/server push |
| PATCH | `/api/v1/alerts/:id/read` | `AlertsRemoteDataSource.markAlertRead()` |
| PATCH | `/api/v1/alerts/:id/resolve` | Resolve alert |
| DELETE| `/api/v1/alerts/:id` | Delete alert |

### Diagnostics
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET  | `/api/v1/diagnostics?bikeId=` | `DiagnosticsRemoteDataSource.getDiagnostics()` |
| GET  | `/api/v1/diagnostics/maintenance?bikeId=` | `DiagnosticsRemoteDataSource.getMaintenanceLogs()` |
| POST | `/api/v1/diagnostics` | IoT push |
| POST | `/api/v1/diagnostics/maintenance` | Log maintenance |

### Tracking  (`ride_locations` table)
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET  | `/api/v1/tracking/route?bikeId=&since=` | `TrackingRemoteDataSource.getRideRoute()` |
| POST | `/api/v1/tracking/location` | IoT GPS push |
| POST | `/api/v1/tracking/location/batch` | Offline GPS flush |

### Analytics  (`ride_sessions` table)
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| GET  | `/api/v1/analytics/sessions` | `AnalyticsRemoteDataSource.getRideSessions()` |
| GET  | `/api/v1/analytics/sessions/:id` | Session detail |
| GET  | `/api/v1/analytics/weekly` | `GetWeeklyStatsUseCase` |
| POST | `/api/v1/analytics/sessions` | Save ride session on end |

### Bike Control  (`bike_commands` table)
| Method | Path | Flutter equivalent |
|--------|------|-------------------|
| POST  | `/api/v1/bike-control/command` | `BikeControlDataSource.sendCommand()` |
| GET   | `/api/v1/bike-control/commands?bikeId=` | Command history |
| PATCH | `/api/v1/bike-control/commands/:id/status` | IoT acknowledgement |

---

## Architecture Notes

- **Supabase Realtime** handles Flutter's `.stream()` calls (`alerts`, `telemetry_logs`,  
  `ride_locations`) — enable those tables in Supabase's Replication dashboard.
- **MQTT** commands are published client-side by Flutter's `MqttService`;  
  this backend only logs them to `bike_commands` for audit.
- **Offline sync**: Flutter buffers telemetry/locations in Hive boxes.  
  On reconnect, call the `/batch` endpoints to flush.
