// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/core/models/audio/audio_fade_model.dart';
import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// Crossfade settings between adjacent audio clips.
class AudioCrossfade {
  /// Creates crossfade settings.
  const AudioCrossfade({
    required this.duration,
    this.curve = AudioFadeCurve.linear,
  }) : assert(duration > Duration.zero, 'duration must be greater than zero');

  /// Crossfade duration.
  final Duration duration;

  /// Fade curve.
  final AudioFadeCurve curve;

  Map<String, dynamic> toMap() {
    return {'durationUs': duration.inMicroseconds, 'curve': curve.name};
  }

  factory AudioCrossfade.fromMap(Map<String, dynamic> map) {
    return AudioCrossfade(
      duration: Duration(microseconds: safeParseInt(map['durationUs'])),
      curve: AudioFadeCurve.values.byName(map['curve'] as String? ?? 'linear'),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioCrossfade.fromJson(String source) =>
      AudioCrossfade.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    return other is AudioCrossfade &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}

/// Loudness normalization target for export.
class LoudnessNormalization {
  /// Creates loudness normalization settings.
  const LoudnessNormalization({this.targetLufs = -16, this.truePeakDb = -1});

  /// Integrated loudness target in LUFS.
  final double targetLufs;

  /// True peak ceiling in dBTP.
  final double truePeakDb;

  Map<String, dynamic> toMap() {
    return {'targetLufs': targetLufs, 'truePeakDb': truePeakDb};
  }

  factory LoudnessNormalization.fromMap(Map<String, dynamic> map) {
    return LoudnessNormalization(
      targetLufs: safeParseDouble(map['targetLufs'], fallback: -16),
      truePeakDb: safeParseDouble(map['truePeakDb'], fallback: -1),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoudnessNormalization &&
        other.targetLufs == targetLufs &&
        other.truePeakDb == truePeakDb;
  }

  @override
  int get hashCode => Object.hash(targetLufs, truePeakDb);
}

/// Background-music ducking under voice or source audio.
class AudioDucking {
  /// Creates ducking settings.
  const AudioDucking({
    this.thresholdDb = -28,
    this.duckToVolume = 0.35,
    this.attack = const Duration(milliseconds: 80),
    this.release = const Duration(milliseconds: 350),
  }) : assert(duckToVolume >= 0, 'duckToVolume must not be negative'),
       assert(attack >= Duration.zero, 'attack must not be negative'),
       assert(release >= Duration.zero, 'release must not be negative');

  /// Detector threshold in dB.
  final double thresholdDb;

  /// Volume multiplier while ducked.
  final double duckToVolume;

  /// Time to enter ducking.
  final Duration attack;

  /// Time to leave ducking.
  final Duration release;

  Map<String, dynamic> toMap() {
    return {
      'thresholdDb': thresholdDb,
      'duckToVolume': duckToVolume,
      'attackUs': attack.inMicroseconds,
      'releaseUs': release.inMicroseconds,
    };
  }

  factory AudioDucking.fromMap(Map<String, dynamic> map) {
    return AudioDucking(
      thresholdDb: safeParseDouble(map['thresholdDb'], fallback: -28),
      duckToVolume: safeParseDouble(map['duckToVolume'], fallback: 0.35),
      attack: Duration(microseconds: safeParseInt(map['attackUs'])),
      release: Duration(microseconds: safeParseInt(map['releaseUs'])),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AudioDucking &&
        other.thresholdDb == thresholdDb &&
        other.duckToVolume == duckToVolume &&
        other.attack == attack &&
        other.release == release;
  }

  @override
  int get hashCode => Object.hash(thresholdDb, duckToVolume, attack, release);
}

/// Pan/balance controls for an audio source.
class AudioPan {
  /// Creates pan settings.
  const AudioPan({this.pan = 0})
    : assert(pan >= -1 && pan <= 1, 'pan must be between -1 and 1');

  /// -1.0 is left, 0.0 is center, and 1.0 is right.
  final double pan;

  Map<String, dynamic> toMap() => {'pan': pan};

  factory AudioPan.fromMap(Map<String, dynamic> map) {
    return AudioPan(pan: safeParseDouble(map['pan'], fallback: 0));
  }

  @override
  bool operator ==(Object other) {
    return other is AudioPan && other.pan == pan;
  }

  @override
  int get hashCode => pan.hashCode;
}

/// Voice-over recording helper configuration.
class VoiceOverRecordingConfig {
  /// Creates a voice-over recording configuration.
  const VoiceOverRecordingConfig({
    this.sampleRate = 44100,
    this.channelCount = 1,
    this.format = VoiceOverFormat.wav,
  }) : assert(sampleRate > 0, 'sampleRate must be greater than 0'),
       assert(channelCount > 0, 'channelCount must be greater than 0');

  /// Requested sample rate.
  final int sampleRate;

  /// Requested channel count.
  final int channelCount;

  /// Recording format.
  final VoiceOverFormat format;

  Map<String, dynamic> toMap() {
    return {
      'sampleRate': sampleRate,
      'channelCount': channelCount,
      'format': format.name,
    };
  }

  factory VoiceOverRecordingConfig.fromMap(Map<String, dynamic> map) {
    return VoiceOverRecordingConfig(
      sampleRate: safeParseInt(map['sampleRate']),
      channelCount: safeParseInt(map['channelCount']),
      format: VoiceOverFormat.values.byName(map['format'] as String? ?? 'wav'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VoiceOverRecordingConfig &&
        other.sampleRate == sampleRate &&
        other.channelCount == channelCount &&
        other.format == format;
  }

  @override
  int get hashCode => Object.hash(sampleRate, channelCount, format);
}

/// Voice-over recording format.
enum VoiceOverFormat { wav, m4a, aac }
