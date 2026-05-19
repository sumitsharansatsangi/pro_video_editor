// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// Inserts a freeze frame (paused still) at a specific timestamp in a clip.
///
/// The frame at [timestamp] is rendered as a still image for [duration],
/// after which the video resumes from [timestamp].
///
/// **Platform support:** Not yet implemented natively. This model defines the
/// API contract; native implementations will be added per platform.
class FreezeFrame {
  /// Creates a [FreezeFrame].
  const FreezeFrame({
    required this.timestamp,
    required this.duration,
  }) : assert(duration > Duration.zero, 'duration must be greater than zero');

  /// Position in the clip at which to grab the frozen frame.
  final Duration timestamp;

  /// How long the frozen frame is displayed.
  final Duration duration;

  /// Converts this freeze frame into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'timestampUs': timestamp.inMicroseconds,
      'durationUs': duration.inMicroseconds,
    };
  }

  /// Creates a [FreezeFrame] from a map.
  factory FreezeFrame.fromMap(Map<String, dynamic> map) {
    return FreezeFrame(
      timestamp: Duration(microseconds: safeParseInt(map['timestampUs'])),
      duration: Duration(microseconds: safeParseInt(map['durationUs'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory FreezeFrame.fromJson(String source) =>
      FreezeFrame.fromMap(json.decode(source) as Map<String, dynamic>);

  FreezeFrame copyWith({Duration? timestamp, Duration? duration}) {
    return FreezeFrame(
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() =>
      'FreezeFrame(timestamp: $timestamp, duration: $duration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FreezeFrame &&
        other.timestamp == timestamp &&
        other.duration == duration;
  }

  @override
  int get hashCode => timestamp.hashCode ^ duration.hashCode;

  // ignore: unused_element
  static double? _unused(Map<String, dynamic> map) => tryParseDouble(map['_']);
}
