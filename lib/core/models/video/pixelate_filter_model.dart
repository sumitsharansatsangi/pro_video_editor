// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/models/time_range_mixin.dart';
import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// A pixelate/censor effect with an optional active time range and region.
///
/// When [rect] is null the entire frame is pixelated. When [rect] is set only
/// that normalised sub-region (values 0.0–1.0) is pixelated, which is useful
/// for censoring a specific area such as a face or licence plate.
class PixelateFilter with TimeRangeMixin {
  /// Creates a pixelate filter.
  ///
  /// [blockSize] controls pixel block size in output pixels (higher = coarser).
  /// [rect] is a normalised region [x, y, width, height] in 0.0–1.0 range.
  PixelateFilter({
    required this.blockSize,
    this.rect,
    this.startTime,
    this.endTime,
  })  : assert(blockSize > 0, 'blockSize must be greater than 0'),
        assert(
          startTime == null || endTime == null || startTime < endTime,
          'startTime must be before endTime',
        ),
        assert(
          rect == null || rect.length == 4,
          'rect must have exactly 4 elements [x, y, width, height]',
        );

  /// Block size in output pixels. Higher values produce coarser pixelation.
  ///
  /// For example, `8` produces 8×8 blocks; `32` produces very coarse blocks.
  final double blockSize;

  /// Normalised region to pixelate: [x, y, width, height] in 0.0–1.0.
  ///
  /// When null, the entire frame is pixelated.
  final List<double>? rect;

  @override
  final Duration? startTime;

  @override
  final Duration? endTime;

  /// Converts this filter into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'blockSize': blockSize,
      'rect': rect,
      'startUs': startTime?.inMicroseconds,
      'endUs': endTime?.inMicroseconds,
    };
  }

  /// Creates a pixelate filter from a map.
  factory PixelateFilter.fromMap(Map<String, dynamic> map) {
    return PixelateFilter(
      blockSize: safeParseDouble(map['blockSize']),
      rect: map['rect'] != null
          ? List<double>.from(
              (map['rect'] as List).map((e) => (e as num).toDouble()),
            )
          : null,
      startTime: map['startUs'] != null
          ? Duration(microseconds: safeParseInt(map['startUs']))
          : null,
      endTime: map['endUs'] != null
          ? Duration(microseconds: safeParseInt(map['endUs']))
          : null,
    );
  }

  /// Converts this filter to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a pixelate filter from JSON.
  factory PixelateFilter.fromJson(String source) =>
      PixelateFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  PixelateFilter copyWith({
    double? blockSize,
    List<double>? rect,
    Duration? startTime,
    Duration? endTime,
  }) {
    return PixelateFilter(
      blockSize: blockSize ?? this.blockSize,
      rect: rect ?? this.rect,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() =>
      'PixelateFilter(blockSize: $blockSize, rect: $rect, '
      'startTime: $startTime, endTime: $endTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PixelateFilter &&
        other.blockSize == blockSize &&
        other.rect == rect &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode =>
      blockSize.hashCode ^
      rect.hashCode ^
      startTime.hashCode ^
      endTime.hashCode;
}
