import '/core/models/video/video_segment_model.dart';

/// Helpers for editing lists of [VideoSegment] objects.
class VideoTimelineUtils {
  const VideoTimelineUtils._();

  /// Splits [segment] at [offset] relative to the segment's output timeline.
  ///
  /// The segment must have an explicit [VideoSegment.endTime] so the helper can
  /// validate the split point. Playback speed is respected when converting the
  /// output offset back to the source timestamp.
  static List<VideoSegment> splitSegment(
    VideoSegment segment,
    Duration offset,
  ) {
    if (offset <= Duration.zero) {
      throw ArgumentError.value(offset, 'offset', 'must be greater than zero');
    }

    final startTime = segment.startTime ?? Duration.zero;
    final endTime = segment.endTime;
    if (endTime == null) {
      throw ArgumentError('segment.endTime is required to split a segment');
    }

    final outputDuration = _outputDuration(segment);
    if (offset >= outputDuration) {
      throw ArgumentError.value(
        offset,
        'offset',
        'must be before the segment end',
      );
    }

    final splitTime = startTime + _sourceDuration(segment, offset);
    return [
      segment.copyWith(endTime: splitTime),
      segment.copyWith(startTime: splitTime),
    ];
  }

  /// Deletes the output timeline range from [segments].
  ///
  /// [start] and [end] are composition times, not source video times. Every
  /// segment must have an explicit [VideoSegment.endTime].
  static List<VideoSegment> deleteRange(
    List<VideoSegment> segments, {
    required Duration start,
    required Duration end,
  }) {
    if (start < Duration.zero) {
      throw ArgumentError.value(start, 'start', 'must not be negative');
    }
    if (start >= end) {
      throw ArgumentError.value(end, 'end', 'must be after start');
    }

    final result = <VideoSegment>[];
    var cursor = Duration.zero;

    for (final segment in segments) {
      final segmentDuration = _outputDuration(segment);
      final segmentStart = cursor;
      final segmentEnd = cursor + segmentDuration;
      cursor = segmentEnd;

      if (end <= segmentStart || start >= segmentEnd) {
        result.add(segment);
        continue;
      }

      final deleteStart = start > segmentStart ? start : segmentStart;
      final deleteEnd = end < segmentEnd ? end : segmentEnd;

      if (deleteStart > segmentStart) {
        result.add(
          segment.copyWith(
            endTime:
                (segment.startTime ?? Duration.zero) +
                _sourceDuration(segment, deleteStart - segmentStart),
          ),
        );
      }

      if (deleteEnd < segmentEnd) {
        result.add(
          segment.copyWith(
            startTime:
                (segment.startTime ?? Duration.zero) +
                _sourceDuration(segment, deleteEnd - segmentStart),
          ),
        );
      }
    }

    return result;
  }

  /// Moves a segment from [fromIndex] to [toIndex] and returns a new list.
  static List<VideoSegment> reorderSegments(
    List<VideoSegment> segments, {
    required int fromIndex,
    required int toIndex,
  }) {
    RangeError.checkValidIndex(fromIndex, segments, 'fromIndex');
    RangeError.checkValidIndex(toIndex, segments, 'toIndex');

    final result = List<VideoSegment>.of(segments);
    final segment = result.removeAt(fromIndex);
    result.insert(toIndex, segment);
    return result;
  }

  static Duration _outputDuration(VideoSegment segment) {
    final startTime = segment.startTime ?? Duration.zero;
    final endTime = segment.endTime;
    if (endTime == null) {
      throw ArgumentError('segment.endTime is required for timeline helpers');
    }
    final sourceDuration = endTime - startTime;
    final playbackSpeed = segment.playbackSpeed ?? 1.0;
    return Duration(
      microseconds: (sourceDuration.inMicroseconds / playbackSpeed).round(),
    );
  }

  static Duration _sourceDuration(VideoSegment segment, Duration outputOffset) {
    final playbackSpeed = segment.playbackSpeed ?? 1.0;
    return Duration(
      microseconds: (outputOffset.inMicroseconds * playbackSpeed).round(),
    );
  }
}
