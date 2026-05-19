import 'dart:convert';

import 'package:pro_video_editor/shared/models/time_range_mixin.dart';
import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// A blur effect with an optional active time range.
class BlurFilter with TimeRangeMixin {

  /// Creates a blur filter from a map.
  factory BlurFilter.fromMap(Map<String, dynamic> map) {
    return BlurFilter(
      blur: safeParseDouble(map['blur']),
      startTime: map['startUs'] != null
          ? Duration(microseconds: safeParseInt(map['startUs']))
          : null,
      endTime: map['endUs'] != null
          ? Duration(microseconds: safeParseInt(map['endUs']))
          : null,
    );
  }

  /// Creates a blur filter from JSON.
  factory BlurFilter.fromJson(String source) =>
      BlurFilter.fromMap(json.decode(source) as Map<String, dynamic>);
  /// Creates a blur filter.
  BlurFilter({required this.blur, this.startTime, this.endTime})
    : assert(blur >= 0, 'blur must be greater than or equal to 0'),
      assert(
        startTime == null || endTime == null || startTime < endTime,
        'startTime must be before endTime',
      );

  /// Blur intensity. Higher values produce stronger blur.
  final double blur;

  @override
  final Duration? startTime;

  @override
  final Duration? endTime;

  /// Converts this filter into a serializable map.
  Map<String, dynamic> toMap() {
    return {
      'blur': blur,
      'startUs': startTime?.inMicroseconds,
      'endUs': endTime?.inMicroseconds,
    };
  }

  /// Converts this filter to JSON.
  String toJson() => json.encode(toMap());
}
