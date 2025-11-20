import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

/// Global audio player service to manage audio playback across the app
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentAudioPath;
  int? _currentAudioIndex;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Stream controllers for state updates
  final _playerStateController = StreamController<PlayerState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _isPlayingController = StreamController<bool>.broadcast();

  // Getters
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  String? get currentAudioPath => _currentAudioPath;
  int? get currentAudioIndex => _currentAudioIndex;

  // Streams
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  /// Initialize the audio player service
  void initialize() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _playerStateController.add(state);
      _isPlayingController.add(_isPlaying);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      _durationController.add(duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      _playerStateController.add(PlayerState.completed);
      _isPlayingController.add(false);
    });
  }

  /// Play audio from file path
  Future<void> playAudio({
    required String audioPath,
    int? audioIndex,
  }) async {
    try {
      // If different audio is playing, stop current one
      if (_currentAudioPath != null && _currentAudioPath != audioPath) {
        await stop();
      }

      _currentAudioPath = audioPath;
      _currentAudioIndex = audioIndex;

      await _audioPlayer.play(DeviceFileSource(audioPath));
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }

  /// Pause audio playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Resume audio playback
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Stop audio playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentAudioPath = null;
      _currentAudioIndex = null;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      _isPlaying = false;
      
      // Notify listeners that playback stopped
      _isPlayingController.add(false);
      _playerStateController.add(PlayerState.stopped);
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Seek to specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _currentPosition = position;
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      if (_currentAudioPath != null) {
        await resume();
      }
    }
  }

  /// Check if specific audio is currently playing
  bool isCurrentAudio(String audioPath) {
    return _currentAudioPath == audioPath;
  }

  /// Check if specific audio index is currently playing
  bool isCurrentAudioIndex(int index) {
    return _currentAudioIndex == index;
  }

  /// Dispose resources
  void dispose() {
    stop();
    _audioPlayer.dispose();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
    _isPlayingController.close();
  }
}

