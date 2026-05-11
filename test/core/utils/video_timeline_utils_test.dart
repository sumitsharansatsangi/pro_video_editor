import 'package:flutter_test/flutter_test.dart';
import 'package:pro_video_editor/pro_video_editor.dart';

void main() {
  group('VideoTimelineUtils', () {
    final videoA = EditorVideo.asset('assets/a.mp4');
    final videoB = EditorVideo.asset('assets/b.mp4');

    test('splitSegment splits at output offset', () {
      final segment = VideoSegment(
        video: videoA,
        startTime: const Duration(seconds: 1),
        endTime: const Duration(seconds: 5),
      );

      final result = VideoTimelineUtils.splitSegment(
        segment,
        const Duration(seconds: 2),
      );

      expect(result, hasLength(2));
      expect(result[0].startTime, const Duration(seconds: 1));
      expect(result[0].endTime, const Duration(seconds: 3));
      expect(result[1].startTime, const Duration(seconds: 3));
      expect(result[1].endTime, const Duration(seconds: 5));
    });

    test('splitSegment accounts for playback speed', () {
      final segment = VideoSegment(
        video: videoA,
        startTime: const Duration(seconds: 1),
        endTime: const Duration(seconds: 5),
        playbackSpeed: 2,
      );

      final result = VideoTimelineUtils.splitSegment(
        segment,
        const Duration(seconds: 1),
      );

      expect(result[0].endTime, const Duration(seconds: 3));
      expect(result[1].startTime, const Duration(seconds: 3));
    });

    test('deleteRange trims and removes affected composition range', () {
      final segments = [
        VideoSegment(
          video: videoA,
          startTime: Duration.zero,
          endTime: const Duration(seconds: 4),
        ),
        VideoSegment(
          video: videoB,
          startTime: Duration.zero,
          endTime: const Duration(seconds: 4),
        ),
      ];

      final result = VideoTimelineUtils.deleteRange(
        segments,
        start: const Duration(seconds: 2),
        end: const Duration(seconds: 6),
      );

      expect(result, hasLength(2));
      expect(result[0].video, videoA);
      expect(result[0].startTime, Duration.zero);
      expect(result[0].endTime, const Duration(seconds: 2));
      expect(result[1].video, videoB);
      expect(result[1].startTime, const Duration(seconds: 2));
      expect(result[1].endTime, const Duration(seconds: 4));
    });

    test('reorderSegments moves item and leaves original list unchanged', () {
      final segments = [
        VideoSegment(video: videoA, endTime: const Duration(seconds: 1)),
        VideoSegment(video: videoB, endTime: const Duration(seconds: 1)),
      ];

      final result = VideoTimelineUtils.reorderSegments(
        segments,
        fromIndex: 0,
        toIndex: 1,
      );

      expect(result[0].video, videoB);
      expect(result[1].video, videoA);
      expect(segments[0].video, videoA);
      expect(segments[1].video, videoB);
    });
  });
}
