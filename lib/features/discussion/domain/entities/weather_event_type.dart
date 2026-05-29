/// The six weather-event categories surfaced as chips on the create-post
/// form. Storing the selected type as a structured field on the post doc
/// (in addition to embedding it in the title text) leaves the door open
/// for future filtering — "show me only Storm posts" — without parsing
/// titles.
enum WeatherEventType {
  storm,
  flood,
  heatwave,
  drought,
  wildfire,
  tornado;

  /// Parse a Firestore-stored event-type name back to its enum value.
  /// Returns null for unknown / missing values so the post can still be
  /// rendered as a custom-titled post without a structured type.
  static WeatherEventType? fromName(String? name) {
    if (name == null) return null;
    for (final t in values) {
      if (t.name == name) return t;
    }
    return null;
  }
}
