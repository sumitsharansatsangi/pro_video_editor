// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// The visual type of a transition between two video clips.
enum VideoTransitionType {
  /// Cross-fade (audio and video fade simultaneously).
  fade,

  /// Dissolve (video cross-dissolves; audio blends).
  dissolve,

  /// One clip slides out as the next slides in.
  slide,

  /// A wipe line sweeps across the frame.
  wipe,
}

/// Direction of a [VideoTransitionType.slide] or [VideoTransitionType.wipe].
enum VideoTransitionDirection {
  /// Transition moves from right to left.
  left,

  /// Transition moves from left to right.
  right,

  /// Transition moves from bottom to top.
  up,

  /// Transition moves from top to bottom.
  down,
}

/// A transition effect applied between two consecutive video segments.
///
/// Attach a [VideoTransition] to a [VideoSegment] to specify the transition
/// that should play between that segment and the next one in the sequence.
///
/// **Platform support:** Not all platforms implement transitions yet. Check
/// [VideoEditorCapabilities] at runtime before relying on transitions.
class VideoTransition {
  /// Creates a [VideoTransition].
  const VideoTransition({
    required this.type,
    required this.duration,
    this.direction,
  }) : assert(
          duration > Duration.zero,
          'Transition duration must be greater than zero',
        );

  /// The visual style of the transition.
  final VideoTransitionType type;

  /// How long the transition plays (overlap between adjacent clips).
  final Duration duration;

  /// Direction for [VideoTransitionType.slide] and [VideoTransitionType.wipe].
  ///
  /// Ignored for [VideoTransitionType.fade] and [VideoTransitionType.dissolve].
  final VideoTransitionDirection? direction;

  /// Converts this transition into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'durationUs': duration.inMicroseconds,
      'direction': direction?.name,
    };
  }

  /// Creates a [VideoTransition] from a map.
  factory VideoTransition.fromMap(Map<String, dynamic> map) {
    return VideoTransition(
      type: VideoTransitionType.values.byName(map['type'] as String),
      duration: Duration(microseconds: safeParseInt(map['durationUs'])),
      direction: map['direction'] != null
          ? VideoTransitionDirection.values.byName(map['direction'] as String)
          : null,
    );
  }

  /// Converts this transition to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a [VideoTransition] from JSON.
  factory VideoTransition.fromJson(String source) =>
      VideoTransition.fromMap(json.decode(source) as Map<String, dynamic>);

  VideoTransition copyWith({
    VideoTransitionType? type,
    Duration? duration,
    VideoTransitionDirection? direction,
  }) {
    return VideoTransition(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
    );
  }

  @override
  String toString() =>
      'VideoTransition(type: $type, duration: $duration, '
      'direction: $direction)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoTransition &&
        other.type == type &&
        other.duration == duration &&
        other.direction == direction;
  }

  @override
  int get hashCode => type.hashCode ^ duration.hashCode ^ direction.hashCode;

  // ignore: unused_element
  static double? _unused(Map<String, dynamic> map) => tryParseDouble(map['_']);
}
