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
- [ ] Improve native codec/container support reporting per device.

## P1 - Core Editing Features

- Android status:
  - [x] Add Android image-layer rotation, opacity, z-index, and anchor support.
  - [x] Add Android timed blur filters.
  - [x] Preserve Android timed color filters.
  - [ ] Add Android pixelate/censor effect support.
  - [ ] Add Android first-class text, shape, and sticker layer rasterization.
  - [ ] Add Android per-clip visual transforms and transitions.

- [ ] Add first-class text layers.
- [ ] Add shape layers: rectangle, circle, line, arrow, and highlight box.
- [ ] Add structured sticker/emoji layers.
- [ ] Add per-layer rotation, opacity, blend mode, z-index, and anchor support.
- [ ] Add pixelate/censor layers with time ranges.
- [ ] Add per-time-range blur, pixelate, and color filters.
- [ ] Add per-clip crop, rotate, flip, scale, color filter, volume, and speed.
- [ ] Add transitions between merged segments: fade, dissolve, slide, and wipe.
- [x] Add frame extraction at a specific timestamp.

## P2 - Timeline And Composition

- [x] Add split/cut/delete-range helpers for timeline editing.
- [x] Add clip reorder helpers.
- [ ] Add still-image segments with duration.
- [ ] Add picture-in-picture video overlay support.
- [ ] Add background canvas controls for aspect-ratio changes.
- [ ] Add aspect-ratio presets: original, 1:1, 4:5, 9:16, and 16:9.
- [ ] Add fit modes: cover, contain, stretch, and crop.
- [ ] Add reverse video.
- [ ] Add freeze frame.

## P3 - Audio Editing

- [ ] Add audio fade in/out.
- [ ] Add audio crossfade between segments.
- [ ] Add original audio track selection for videos with multiple tracks.
- [ ] Add replace-original-audio support per segment.
- [ ] Add loudness normalization.
- [ ] Add background music ducking under voice.
- [ ] Add pan/balance controls.
- [ ] Add voice-over recording helper APIs.

## P4 - Export Controls

- [ ] Add FPS control.
- [ ] Add codec selection where supported: H.264, H.265/HEVC, VP9, and AV1.
- [ ] Add more output formats where supported: MOV, WebM, GIF, MP3, and WAV.
- [ ] Add resolution presets independent from bitrate presets.
- [ ] Add hardware/software encoder preference controls.
- [ ] Add export queue helpers.
- [ ] Add pause/resume support for long-running export tasks.

## P5 - Advanced Effects

- [ ] Add typed adjustment APIs for brightness, contrast, saturation, exposure,
      warmth, tint, and sharpen.
- [ ] Add LUT support.
- [ ] Add vignette.
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
