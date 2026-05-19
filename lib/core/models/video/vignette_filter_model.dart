// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';

/// A vignette effect that darkens the edges of the frame.
class VignetteFilter {
  /// Creates a vignette filter.
  ///
  /// [strength] controls the intensity of the vignette (0.0–1.0).
  /// [radius] controls how far from the centre the darkening starts (0.0–1.0).
  /// [feather] controls the softness of the vignette falloff (0.0–1.0).
  const VignetteFilter({
    this.strength = 0.5,
    this.radius = 0.5,
    this.feather = 0.3,
  })  : assert(strength >= 0 && strength <= 1, 'strength must be 0.0–1.0'),
        assert(radius >= 0 && radius <= 1, 'radius must be 0.0–1.0'),
        assert(feather >= 0 && feather <= 1, 'feather must be 0.0–1.0');

  /// Vignette darkness intensity from 0.0 (none) to 1.0 (full black edges).
  final double strength;

  /// How close to the centre the vignette starts. 0.0 = edge, 1.0 = centre.
  final double radius;

  /// Softness of the vignette edge. Higher values produce a smoother gradient.
  final double feather;

  /// Converts this filter into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'strength': strength,
      'radius': radius,
      'feather': feather,
    };
  }

  /// Creates a vignette filter from a map.
  factory VignetteFilter.fromMap(Map<String, dynamic> map) {
    return VignetteFilter(
      strength: safeParseDouble(map['strength'], fallback: 0.5),
      radius: safeParseDouble(map['radius'], fallback: 0.5),
      feather: safeParseDouble(map['feather'], fallback: 0.3),
    );
  }

  /// Converts this filter to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a vignette filter from JSON.
  factory VignetteFilter.fromJson(String source) =>
      VignetteFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  VignetteFilter copyWith({
    double? strength,
    double? radius,
    double? feather,
  }) {
    return VignetteFilter(
      strength: strength ?? this.strength,
      radius: radius ?? this.radius,
      feather: feather ?? this.feather,
    );
  }

  @override
  String toString() =>
      'VignetteFilter(strength: $strength, radius: $radius, feather: $feather)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VignetteFilter &&
        other.strength == strength &&
        other.radius == radius &&
        other.feather == feather;
  }

  @override
  int get hashCode => strength.hashCode ^ radius.hashCode ^ feather.hashCode;
}
