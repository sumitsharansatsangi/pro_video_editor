/// Common aspect ratio presets for canvas/output resolution adjustments.
enum AspectRatioPreset {
  /// Preserve the original video aspect ratio.
  original(width: null, height: null),

  /// 1:1 square (e.g. Instagram square post).
  square(width: 1, height: 1),

  /// 4:5 portrait (e.g. Instagram portrait post).
  portrait4x5(width: 4, height: 5),

  /// 9:16 vertical (e.g. TikTok, Reels, Stories).
  vertical9x16(width: 9, height: 16),

  /// 16:9 landscape (e.g. YouTube, widescreen).
  landscape16x9(width: 16, height: 9),

  /// 4:3 standard (e.g. classic TV ratio).
  standard4x3(width: 4, height: 3),

  /// 3:2 photo (e.g. DSLR photo ratio).
  photo3x2(width: 3, height: 2),

  /// 21:9 ultra-wide (e.g. cinematic).
  ultraWide21x9(width: 21, height: 9);

  const AspectRatioPreset({
    required this.width,
    required this.height,
  });

  /// Rational width component, or null for [original].
  final int? width;

  /// Rational height component, or null for [original].
  final int? height;

  /// The aspect ratio as a double, or null for [original].
  double? get ratio {
    if (width == null || height == null) return null;
    return width! / height!;
  }

  /// Human-readable label for this preset.
  String get label {
    switch (this) {
      case AspectRatioPreset.original:
        return 'Original';
      case AspectRatioPreset.square:
        return '1:1';
      case AspectRatioPreset.portrait4x5:
        return '4:5';
      case AspectRatioPreset.vertical9x16:
        return '9:16';
      case AspectRatioPreset.landscape16x9:
        return '16:9';
      case AspectRatioPreset.standard4x3:
        return '4:3';
      case AspectRatioPreset.photo3x2:
        return '3:2';
      case AspectRatioPreset.ultraWide21x9:
        return '21:9';
    }
  }
}
