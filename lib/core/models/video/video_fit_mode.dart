/// How video content is fitted into the output canvas when the aspect ratio
/// of the source differs from the target.
enum VideoFitMode {
  /// Scale the video so it covers the entire canvas; content may be cropped.
  cover,

  /// Scale the video so it fits entirely within the canvas; letterboxing may
  /// appear.
  contain,

  /// Stretch the video to fill the canvas exactly, ignoring aspect ratio.
  stretch,

  /// Crop the video to a specific region to fill the canvas.
  crop,
}
