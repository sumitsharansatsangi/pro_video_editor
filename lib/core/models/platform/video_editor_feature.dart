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

  /// Extract a frame thumbnail at a specific timestamp.
  frameThumbnail,

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

  /// Apply typed colour-grading adjustments (brightness, contrast, etc.).
  adjustment,

  /// Apply a vignette effect.
  vignette,

  /// Insert transitions between merged video segments.
  transitions,

  /// Insert still-image segments with a specified duration.
  stillImageSegments,

  /// Freeze a frame at a specific timestamp for a specified duration.
  freezeFrame,

  /// Per-clip crop, rotate, flip, scale, and colour transforms.
  perClipTransforms,

  /// Reverse video playback for a clip.
  reverseVideo,

  /// Picture-in-picture video overlay.
  pictureInPicture,

  /// First-class text layers.
  textLayers,

  /// Shape layers such as rectangles, circles, lines, arrows, and highlights.
  shapeLayers,

  /// Structured sticker and emoji layers.
  stickerLayers,

  /// Background canvas controls for aspect-ratio changes.
  backgroundCanvas,

  /// Audio fade in/out.
  audioFade,

  /// Audio crossfade between segments.
  audioCrossfade,

  /// Select an original audio track from multi-track sources.
  originalAudioTrackSelection,

  /// Replace the original audio for a segment or export.
  replaceOriginalAudio,

  /// Loudness normalization.
  loudnessNormalization,

  /// Duck background music under voice.
  audioDucking,

  /// Pan/balance controls.
  audioPan,

  /// Voice-over recording helpers.
  voiceOverRecording,

  /// Select preferred output video codec.
  codecSelection,

  /// Control output frame rate.
  fpsControl,

  /// Select hardware or software encoder preference.
  encoderPreference,

  /// Device-specific codec/container support reporting.
  codecContainerReporting,

  /// Resolution presets independent from bitrate.
  resolutionPresets,

  /// Dart-side export queue helper.
  exportQueue,

  /// Pause/resume queued exports before native work starts.
  exportQueuePauseResume,

  /// LUT color transform support.
  lut,

  /// Grain/noise effect.
  grain,

  /// Chroma key / green-screen effect.
  chromaKey,

  /// Effect and layer masks.
  masks,

  /// Editor UI widgets.
  editorUi,
}
