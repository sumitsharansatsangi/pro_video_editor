/// Video codec preference for export.
///
/// Not all codecs are available on all platforms or devices. Check
/// [VideoEditorCapabilities] at runtime and fall back gracefully.
enum VideoCodec {
  /// H.264 / AVC — widely compatible, good quality/size ratio.
  h264,

  /// H.265 / HEVC — better compression than H.264; requires newer hardware.
  h265,

  /// VP9 — open codec, good web support; requires platform/device support.
  vp9,

  /// AV1 — state-of-the-art open codec; best compression, slowest encoding.
  av1,
}
