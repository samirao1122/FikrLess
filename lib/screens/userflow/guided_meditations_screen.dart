import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import 'mindfulness_practitioners_screen.dart';

class GuidedMeditationsScreen extends StatefulWidget {
  final Locale locale;

  const GuidedMeditationsScreen({super.key, required this.locale});

  @override
  State<GuidedMeditationsScreen> createState() =>
      _GuidedMeditationsScreenState();
}

class _GuidedMeditationsScreenState extends State<GuidedMeditationsScreen> {
  List<Map<String, dynamic>> _audios = [];
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Map<int, bool> _downloadingAudios = {};
  Map<int, bool> _downloadedAudios = {};
  Map<int, String> _localAudioPaths = {};

  @override
  void initState() {
    super.initState();

    // ✅ Set status bar color to match header
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _loadAudios();
    _setupAudioPlayer();
    _checkDownloadedAudios();
  }

  @override
  void dispose() {
    // ✅ Reset status bar when leaving screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  Future<void> _loadAudios() async {
    setState(() {
      _isLoading = true;
    });

    final token = await AuthCacheService.getAuthToken();
    final audioList =
    await SpiritualHubApiService.getGuidedMeditationAudios(token: token);

    if (!mounted) return;

    setState(() {
      _audios = audioList ?? [];

      // Dummy data if API returns nothing
      if (_audios.isEmpty) {
        _audios = [
          {
            'audio_url':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
          },
          {
            'audio_url':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
          },
          {
            'audio_url':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'
          },
          {
            'audio_url':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'
          },
        ];
      }

      _isLoading = false;
    });

    await _checkDownloadedAudios();
  }

  Future<void> _checkDownloadedAudios() async {
    if (_audios.isEmpty) return;

    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/meditation_audios');

    if (await audioDir.exists()) {
      final files = audioDir.listSync();
      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          final match =
          RegExp(r'meditation_(\d+)\.mp3').firstMatch(fileName);
          if (match != null) {
            final index = int.tryParse(match.group(1) ?? '');
            if (index != null && index < _audios.length) {
              _downloadedAudios[index] = true;
              _localAudioPaths[index] = file.path;
            }
          }
        }
      }
    }
  }

  Future<void> _downloadAudio(int index) async {
    if (_downloadingAudios[index] == true ||
        _downloadedAudios[index] == true) {
      return;
    }

    setState(() {
      _downloadingAudios[index] = true;
    });

    try {
      final audioUrl = _audios[index]['audio_url'] as String? ?? '';
      if (audioUrl.isEmpty) {
        throw Exception('Invalid audio URL');
      }

      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final audioDir = Directory('${directory.path}/meditation_audios');
        if (!await audioDir.exists()) {
          await audioDir.create(recursive: true);
        }

        final fileName = 'meditation_$index.mp3';
        final file = File('${audioDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        if (!mounted) return;

        setState(() {
          _downloadingAudios[index] = false;
          _downloadedAudios[index] = true;
          _localAudioPaths[index] = file.path;
        });
      } else {
        throw Exception('Failed to download audio');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloadingAudios[index] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download audio: $e')),
      );
    }
  }

  Future<void> _playPauseAudio(int index) async {
    if (_downloadedAudios[index] != true) {
      await _downloadAudio(index);
      if (_downloadedAudios[index] != true) {
        return;
      }
    }

    if (_currentlyPlayingIndex == index && _isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_currentlyPlayingIndex != null &&
          _currentlyPlayingIndex != index) {
        await _audioPlayer.stop();
      }
      final audioPath = _localAudioPaths[index]!;
      await _audioPlayer.play(DeviceFileSource(audioPath));
      setState(() {
        _currentlyPlayingIndex = index;
        _isPlaying = true;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // ✅ Let header paint behind the status bar
        bottom: true,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _audios.isEmpty
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .noMeditationsAvailable,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
                  : Padding(
                padding:
                EdgeInsets.only(bottom: bottomPadding),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _audios.length,
                  itemBuilder: (context, index) {
                    return _buildAudioCard(index);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: bottomPadding > 0 ? bottomPadding : 20,
                top: 8,
              ),
              child: _buildLearnMoreButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final localizations = AppLocalizations.of(context)!;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: statusBarHeight + 120, // ✅ Covers status bar + header height
      decoration: const BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: statusBarHeight + 16, // ✅ content starts below status bar
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                localizations.spiritualHub,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48), // balances back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioCard(int index) {
    final localizations = AppLocalizations.of(context)!;
    final isCurrentlyPlaying = _currentlyPlayingIndex == index;
    final isDownloaded = _downloadedAudios[index] ?? false;
    final isDownloading = _downloadingAudios[index] ?? false;

    final progress = isCurrentlyPlaying && _totalDuration.inSeconds > 0
        ? _currentPosition.inSeconds / _totalDuration.inSeconds
        : 0.0;
    final currentTime =
    isCurrentlyPlaying ? _currentPosition : Duration.zero;
    final totalTime = isCurrentlyPlaying && _totalDuration.inSeconds > 0
        ? _totalDuration
        : const Duration(minutes: 10);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play / Pause
          GestureDetector(
            onTap: () => _playPauseAudio(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: isDownloading
                  ? const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : Image.asset(
                isCurrentlyPlaying && _isPlaying
                    ? 'assets/images/home_directory/audio_pause.png'
                    : 'assets/images/home_directory/audio_play.png',
                width: 16,
                height: 16,
                color: isCurrentlyPlaying && _isPlaying
                    ? Colors.red
                    : AppColors.textPrimary,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    isCurrentlyPlaying && _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: isCurrentlyPlaying && _isPlaying
                        ? Colors.red
                        : AppColors.textPrimary,
                    size: 16,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.meditation(index + 1),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) async {
                        if (_totalDuration.inSeconds > 0) {
                          final newProgress =
                          (details.localPosition.dx /
                              constraints.maxWidth)
                              .clamp(0.0, 1.0);
                          final newPosition = Duration(
                            seconds: (newProgress *
                                _totalDuration.inSeconds)
                                .toInt(),
                          );
                          await _audioPlayer.seek(newPosition);
                          setState(() {
                            _currentPosition = newPosition;
                          });
                        }
                      },
                      onHorizontalDragUpdate: (details) async {
                        if (_totalDuration.inSeconds > 0 &&
                            isCurrentlyPlaying) {
                          final newProgress =
                          (details.localPosition.dx /
                              constraints.maxWidth)
                              .clamp(0.0, 1.0);
                          final newPosition = Duration(
                            seconds: (newProgress *
                                _totalDuration.inSeconds)
                                .toInt(),
                          );
                          await _audioPlayer.seek(newPosition);
                          setState(() {
                            _currentPosition = newPosition;
                          });
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.colorShadow,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            AppColors.accentTeal,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(currentTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatDuration(totalTime),
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
          const SizedBox(width: 8),
          if (!isDownloaded && !isDownloading)
            GestureDetector(
              onTap: () => _downloadAudio(index),
              child: const Icon(
                Icons.download,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLearnMoreButton() {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MindfulnessPractitionersScreen(locale: widget.locale),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          localizations.learnMore,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
