/// In-memory details returned by the Dornye rider portal's custom session.
/// Fleet riders do not have a Supabase Auth session in the telemetry project,
/// so downstream features cannot retrieve their fleet bike from `bikes`.
class PortalSessionCache {
  PortalSessionCache._();

  static Map<String, dynamic>? bike;

  static void clear() => bike = null;
}
