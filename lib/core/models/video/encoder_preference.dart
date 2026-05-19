/// Preferred encoder type for video export.
///
/// When the preferred encoder is unavailable the platform will fall back
/// automatically.
enum EncoderPreference {
  /// Let the platform choose (default).
  auto,

  /// Prefer hardware acceleration when available.
  hardware,

  /// Use software encoding only. Slower but more consistent across devices.
  software,
}
