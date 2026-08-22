/// In-memory details returned by the Dornye rider portal's custom session.
/// Fleet riders do not have a Supabase Auth session in the telemetry project,
/// so downstream features cannot retrieve their fleet bike from `bikes`.
class PortalSessionCache {
  PortalSessionCache._();

  static Map<String, dynamic>? bike;
  static String? sessionToken;
  static String? riderId;
  static String? riderEmail;

  static void clear() {
    bike = null;
    sessionToken = null;
    riderId = null;
    riderEmail = null;
  }
}
