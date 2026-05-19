// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// Audio fade direction.
enum AudioFadeDirection {
  /// Volume ramps up from silence to full at the start of the clip.
  fadeIn,

  /// Volume ramps down from full to silence at the end of the clip.
  fadeOut,

  /// Volume ramps up at the start and down at the end.
  fadeInOut,
}

/// Audio fade curve type.
enum AudioFadeCurve {
  /// Linear ramp.
  linear,

  /// Logarithmic ramp (sounds more natural).
  logarithmic,

  /// Exponential ramp.
  exponential,
}

/// Configures a volume fade-in, fade-out, or both for an audio track or clip.
class AudioFade {
  /// Creates an [AudioFade].
  const AudioFade({
    required this.direction,
    required this.duration,
    this.curve = AudioFadeCurve.linear,
  }) : assert(
          duration > Duration.zero,
          'Fade duration must be greater than zero',
        );

  /// Convenience constructor for a simple fade-in.
  const AudioFade.fadeIn({
    required Duration duration,
    AudioFadeCurve curve = AudioFadeCurve.linear,
  }) : this(
          direction: AudioFadeDirection.fadeIn,
          duration: duration,
          curve: curve,
        );

  /// Convenience constructor for a simple fade-out.
  const AudioFade.fadeOut({
    required Duration duration,
    AudioFadeCurve curve = AudioFadeCurve.linear,
  }) : this(
          direction: AudioFadeDirection.fadeOut,
          duration: duration,
          curve: curve,
        );

  /// Whether to fade in, out, or both.
  final AudioFadeDirection direction;

  /// Duration of the fade ramp (applied to each side for
  /// [AudioFadeDirection.fadeInOut]).
  final Duration duration;

  /// The curve shape of the volume ramp.
  final AudioFadeCurve curve;

  AudioFade copyWith({
    AudioFadeDirection? direction,
    Duration? duration,
    AudioFadeCurve? curve,
  }) {
    return AudioFade(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  /// Converts this fade into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'direction': direction.name,
      'durationUs': duration.inMicroseconds,
      'curve': curve.name,
    };
  }

  factory AudioFade.fromMap(Map<String, dynamic> map) {
    final curveName = map['curve'] as String?;
    return AudioFade(
      direction:
          AudioFadeDirection.values.byName(map['direction'] as String),
      duration: Duration(microseconds: safeParseInt(map['durationUs'])),
      curve: curveName != null
          ? AudioFadeCurve.values.byName(curveName)
          : AudioFadeCurve.linear,
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioFade.fromJson(String source) =>
      AudioFade.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AudioFade(direction: $direction, duration: $duration, curve: $curve)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioFade &&
        other.direction == direction &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode =>
      direction.hashCode ^ duration.hashCode ^ curve.hashCode;
}
