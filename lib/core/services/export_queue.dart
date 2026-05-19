import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:pro_video_editor/pro_video_editor.dart';

/// Signature for a queued export operation.
typedef VideoExportTask = Future<Uint8List> Function();

/// Signature for a queued file export operation.
typedef VideoFileExportTask = Future<String> Function();

/// State of a queued export job.
enum ExportQueueJobState {
  /// Waiting for the queue to run it.
  queued,

  /// Running now.
  running,

  /// Queue is paused before this job has started.
  paused,

  /// Finished successfully.
  completed,

  /// Failed with an error.
  failed,

  /// Cancelled before completion.
  canceled,
}

/// A handle for a queued export job.
class ExportQueueJob<T> {
  ExportQueueJob._({required this.id, required this.run});

  /// Job identifier.
  final String id;

  /// Work to run when this job reaches the front of the queue.
  final Future<T> Function() run;

  final _completer = Completer<T>();
  final _stateCtrl = StreamController<ExportQueueJobState>.broadcast();

  ExportQueueJobState _state = ExportQueueJobState.queued;

  /// Current job state.
  ExportQueueJobState get state => _state;

  /// Completes with this job's result.
  Future<T> get future => _completer.future;

  /// Emits state changes for this job.
  Stream<ExportQueueJobState> get stateStream => _stateCtrl.stream;

  void _setState(ExportQueueJobState value) {
    if (_state == value) return;
    _state = value;
    if (!_stateCtrl.isClosed) _stateCtrl.add(value);
  }

  void _complete(T value) {
    _setState(ExportQueueJobState.completed);
    if (!_completer.isCompleted) _completer.complete(value);
    _stateCtrl.close();
  }

  void _completeError(Object error, StackTrace stackTrace) {
    _setState(ExportQueueJobState.failed);
    if (!_completer.isCompleted) _completer.completeError(error, stackTrace);
    _stateCtrl.close();
  }

  void _cancel() {
    _setState(ExportQueueJobState.canceled);
    if (!_completer.isCompleted) {
      _completer.completeError(StateError('Export job $id was canceled'));
    }
    _stateCtrl.close();
  }
}

/// A FIFO helper for serializing export work.
///
/// The queue coordinates Dart-side scheduling. Native pause/resume of an
/// already-running encoder is platform-dependent, so [pause] prevents the next
/// queued item from starting and does not suspend a job that is already inside
/// a native render call.
class ExportQueue {
  /// Creates an export queue.
  ExportQueue({this.maxConcurrent = 1})
    : assert(maxConcurrent > 0, 'maxConcurrent must be greater than 0');

  /// Maximum number of jobs to run at the same time.
  final int maxConcurrent;

  final Queue<ExportQueueJob<Object?>> _pending = Queue();
  final Set<ExportQueueJob<Object?>> _running = {};

  bool _paused = false;

  /// Whether the queue is paused.
  bool get isPaused => _paused;

  /// Number of queued jobs waiting to start.
  int get pendingCount => _pending.length;

  /// Number of jobs currently running.
  int get runningCount => _running.length;

  /// Adds a custom export task.
  ExportQueueJob<T> add<T>({
    required String id,
    required Future<T> Function() run,
  }) {
    final job = ExportQueueJob<T>._(id: id, run: run);
    _pending.add(job as ExportQueueJob<Object?>);
    _drain();
    return job;
  }

  /// Adds a memory render task.
  ExportQueueJob<Uint8List> addRender(
    VideoRenderData data, {
    NativeLogLevel? nativeLogLevel,
  }) {
    return add<Uint8List>(
      id: data.id,
      run: () => ProVideoEditor.instance.renderVideo(
        data,
        nativeLogLevel: nativeLogLevel,
      ),
    );
  }

  /// Adds a file render task.
  ExportQueueJob<String> addRenderToFile(
    String filePath,
    VideoRenderData data, {
    NativeLogLevel? nativeLogLevel,
  }) {
    return add<String>(
      id: data.id,
      run: () => ProVideoEditor.instance.renderVideoToFile(
        filePath,
        data,
        nativeLogLevel: nativeLogLevel,
      ),
    );
  }

  /// Pauses the queue before starting additional jobs.
  void pause() {
    _paused = true;
    for (final job in _pending) {
      job._setState(ExportQueueJobState.paused);
    }
  }

  /// Resumes the queue.
  void resume() {
    _paused = false;
    for (final job in _pending) {
      job._setState(ExportQueueJobState.queued);
    }
    _drain();
  }

  /// Cancels a queued job. Running native work should be cancelled through
  /// [ProVideoEditor.cancel] using the render task id.
  bool cancelQueued(String id) {
    for (final job in List<ExportQueueJob<Object?>>.of(_pending)) {
      if (job.id == id) {
        _pending.remove(job);
        job._cancel();
        return true;
      }
    }
    return false;
  }

  void _drain() {
    if (_paused) return;

    while (_running.length < maxConcurrent && _pending.isNotEmpty) {
      final job = _pending.removeFirst();
      _running.add(job);
      job._setState(ExportQueueJobState.running);

      unawaited(
        job
            .run()
            .then(job._complete)
            .catchError(job._completeError)
            .whenComplete(_drainAfterJob(job)),
      );
    }
  }

  void Function() _drainAfterJob(ExportQueueJob<Object?> job) {
    return () {
      _running.remove(job);
      _drain();
    };
  }
}
