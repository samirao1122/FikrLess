import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/audio_player_service.dart';
import '../screens/userflow/wellness/guided_meditations_screen.dart';

/// Floating audio player notification widget (like MX Player/VLC)
/// Shows current audio, progress, and controls
class AudioPlayerNotification extends StatefulWidget {
  final Locale locale;

  const AudioPlayerNotification({
    super.key,
    required this.locale,
  });

  @override
  State<AudioPlayerNotification> createState() => _AudioPlayerNotificationState();
}

class _AudioPlayerNotificationState extends State<AudioPlayerNotification> {
  final AudioPlayerService _audioService = AudioPlayerService();
  bool _isVisible = false;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _currentAudioName;
  
  StreamSubscription? _isPlayingSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  Timer? _visibilityCheckTimer;

  @override
  void initState() {
    super.initState();
    _setupListeners();
    _checkInitialState();
    _startVisibilityCheck();
  }

  void _startVisibilityCheck() {
    // Check visibility periodically to catch when audio stops
    _visibilityCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        final wasVisible = _isVisible;
        _updateVisibility();
        if (wasVisible != _isVisible) {
          setState(() {});
        }
      }
    });
  }

  void _setupListeners() {
    // Listen to playing state
    _isPlayingSubscription = _audioService.isPlayingStream.listen((isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = isPlaying;
          _updateVisibility();
        });
      }
    });

    // Listen to position updates
    _positionSubscription = _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to duration updates
    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });
  }

  void _updateVisibility() {
    _isVisible = _audioService.currentAudioPath != null;
  }

  Future<void> _checkInitialState() async {
    // Check if audio is already playing
    if (mounted) {
      setState(() {
        _isPlaying = _audioService.isPlaying;
        _currentPosition = _audioService.currentPosition;
        _totalDuration = _audioService.totalDuration;
        _updateVisibility();
        _currentAudioName = _getAudioName();
      });
    }
  }

  String _getAudioName() {
    final index = _audioService.currentAudioIndex;
    if (index != null) {
      return 'Meditation ${index + 1}';
    }
    return 'Audio';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _navigateToMeditations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuidedMeditationsScreen(locale: widget.locale),
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  Future<void> _stop() async {
    await _audioService.stop();
  }

  @override
  void dispose() {
    _isPlayingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _visibilityCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final progress = _totalDuration.inSeconds > 0
        ? _currentPosition.inSeconds / _totalDuration.inSeconds
        : 0.0;

    return Positioned(
      bottom: 60, // Position above bottom navigation bar
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _navigateToMeditations,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) async {
                        if (_totalDuration.inSeconds > 0) {
                          final x = details.localPosition.dx;
                          final width = constraints.maxWidth;
                          final newProgress = (x / width).clamp(0.0, 1.0);
                          final newPosition = Duration(
                            seconds: (newProgress * _totalDuration.inSeconds).toInt(),
                          );
                          await _audioService.seek(newPosition);
                        }
                      },
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.colorShadow,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentTeal,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      // Play/Pause button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Audio info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getAudioName(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  ' / ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_totalDuration),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Stop button
                      GestureDetector(
                        onTap: _stop,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

