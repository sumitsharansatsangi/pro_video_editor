# TODO

This roadmap is ordered by practical impact for the package: platform parity,
core editor capabilities, then advanced editing polish.

## P0 - Platform Parity And Stability

- [x] Add a public platform capability API, for example
      `ProVideoEditor.instance.getSupportedFeatures()`.
- [x] Return clear unsupported-feature exceptions instead of generic platform
      errors.
- [ ] Add Windows render/export support.
- [ ] Add Linux render/export support.
- [ ] Add Windows thumbnail and keyframe generation support.
- [ ] Add Linux thumbnail and keyframe generation support.
- [ ] Add Windows/Linux waveform and audio extraction support.
- [ ] Add safer large-file file-based workflows for all heavy operations.
- [x] Improve native codec/container support reporting per device.

## P1 - Core Editing Features

- Android status:
  - [x] Add Android image-layer rotation, opacity, z-index, and anchor support.
  - [x] Add Android timed blur filters.
  - [x] Preserve Android timed color filters.
  - [ ] Add Android pixelate/censor effect support.
  - [x] Add Android first-class text, shape, and sticker layer rasterization.
  - [ ] Add Android per-clip visual transforms and transitions.

- [x] Add first-class text layers.
- [x] Add shape layers: rectangle, circle, line, arrow, and highlight box.
- [x] Add structured sticker/emoji layers.
- [x] Add per-layer rotation, opacity, blend mode, z-index, and anchor support.
- [x] Add pixelate/censor layers with time ranges (`PixelateFilter` model +
      `VideoEditorFeature.pixelateLayers`; Android native pending).
- [x] Add per-time-range blur, pixelate, and color filters (blur and color
      already functional; pixelate model added).
- [x] Add per-clip crop, rotate, flip, scale, color filter, volume, and speed
      (`VideoSegment.transform`, `colorFilters`, `blurFilters`, `reversed`).
- [x] Add transitions between merged segments (`VideoTransition` model +
      `VideoEditorFeature.transitions`; native pending).
- [x] Add frame extraction at a specific timestamp.

## P2 - Timeline And Composition

- [x] Add split/cut/delete-range helpers for timeline editing.
- [x] Add clip reorder helpers.
- [x] Add still-image segments with duration (`StillImageSegment` model;
      native pending).
- [x] Add picture-in-picture video overlay support.
- [x] Add background canvas controls for aspect-ratio changes.
- [x] Add aspect-ratio presets: original, 1:1, 4:5, 9:16, and 16:9
      (`AspectRatioPreset` enum).
- [x] Add fit modes: cover, contain, stretch, and crop (`VideoFitMode` enum).
- [x] Add reverse video (`VideoSegment.reversed` field;
      `VideoEditorFeature.reverseVideo`; native pending).
- [x] Add freeze frame (`FreezeFrame` model; native pending).

## P3 - Audio Editing

- [x] Add audio fade in/out (`AudioFade` model + `VideoEditorFeature.audioFade`;
      native pending).
- [x] Add audio crossfade between segments.
- [x] Add original audio track selection for videos with multiple tracks.
- [x] Add replace-original-audio support per segment.
- [x] Add loudness normalization.
- [x] Add background music ducking under voice.
- [x] Add pan/balance controls.
- [x] Add voice-over recording helper APIs.

## P4 - Export Controls

- [x] Add FPS control (`VideoRenderData.fps` field;
      `VideoEditorFeature.fpsControl`; native pending).
- [x] Add codec selection where supported: H.264, H.265/HEVC, VP9, and AV1
      (`VideoCodec` enum + `VideoRenderData.codec`;
      `VideoEditorFeature.codecSelection`; native pending).
- [x] Add more output formats where supported: MOV, WebM, GIF, MP3, and WAV
      (`VideoOutputFormat.webm/gif/mp3/wav`; native pending per platform).
- [x] Add resolution presets independent from bitrate presets.
- [x] Add hardware/software encoder preference controls (`EncoderPreference`
      enum + `VideoRenderData.encoderPreference`;
      `VideoEditorFeature.encoderPreference`; native pending).
- [x] Add export queue helpers.
- [x] Add pause/resume support for queued export tasks.

## P5 - Advanced Effects

- [x] Add typed adjustment APIs for brightness, contrast, saturation, exposure,
      warmth, tint, and sharpen (`VideoAdjustment` model;
      Android supported via Media3; iOS/macOS pending).
- [ ] Add LUT support.
- [x] Add vignette (`VignetteFilter` model + `VideoEditorFeature.vignette`;
      native pending).
- [ ] Add grain/noise.
- [ ] Add chroma key/green-screen support.
- [ ] Add masks for effects and layers.

## P6 - Editor UI Package

- [ ] Decide whether this package should ship editor UI widgets or stay focused
      on processing APIs.
- [ ] Add timeline UI widgets if UI support is in scope.
- [ ] Add trim handles and clip controls.
- [ ] Add layer canvas editor widgets.
- [ ] Add preview player controls.
- [ ] Add export progress UI.
- [ ] Add filter, crop, rotate, audio, and layer editing panels.

## Test Fixes

### macOS

- [ ] Test: Merge AC3 audio (F) with AAC audio (A)
- [ ] Test: Merge AAC audio (A) with AC3 audio (F)
- [ ] Test: Merge all test videos (A + B + C + D + E + F)
- [ ] Test: Merge large 4K files (~1GB total)

### iOS

- [ ] Test: Merge AC3 audio (F) with AAC audio (A)
- [ ] Test: Merge AAC audio (A) with AC3 audio (F)
- [ ] Test: Merge all test videos (A + B + C + D + E + F)
- [ ] Test: Merge large 4K files (~1GB total)
