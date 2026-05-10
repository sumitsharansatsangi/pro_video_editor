/// Features that can be supported by a platform implementation.
enum VideoEditorFeature {
  /// Extract video metadata.
  metadata,

  /// Check whether a video contains audio.
  hasAudioTrack,

  /// Generate multiple thumbnails.
  thumbnails,

  /// Generate scene/key frame thumbnails.
  keyFrames,

  /// Generate one thumbnail at the first or last frame.
  singleThumbnail,

  /// Render a video and return the bytes in memory.
  renderVideo,

  /// Render a video directly to a file.
  renderVideoToFile,

  /// Cancel a running task.
  cancel,

  /// Extract audio and return the bytes in memory.
  extractAudio,

  /// Extract audio directly to a file.
  extractAudioToFile,

  /// Generate waveform data.
  waveform,

  /// Stream waveform data progressively.
  waveformStreaming,

  /// Rotate video output.
  rotate,

  /// Flip video output.
  flip,

  /// Crop video output.
  crop,

  /// Scale video output.
  scale,

  /// Trim video output.
  trim,

  /// Merge multiple video segments.
  mergeVideos,

  /// Adjust playback speed.
  playbackSpeed,

  /// Remove or mute source audio.
  muteAudio,

  /// Overlay image layers.
  imageLayers,

  /// Overlay image layers with start/end times.
  timedImageLayers,

  /// Animate image layers.
  layerAnimations,

  /// Apply color matrix filters.
  colorFilters,

  /// Apply blur effects.
  blur,

  /// Mix custom audio tracks.
  customAudioTracks,

  /// Optimize MP4 output for progressive network playback.
  streamingOptimization,

  /// Pixelate/censor parts of the video.
  pixelateLayers,
}
