import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import '../../services/step_counter_service.dart';
import '../../utils/mood_helper.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Locale locale;
  final int? currentSteps;
  final String? currentMood;

  const ProfileScreen({
    super.key,
    required this.locale,
    this.currentSteps,
    this.currentMood,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StepCounterService _stepCounterService = StepCounterService();
  int _currentSteps = 0;
  String _currentMood = 'Happy';
  String _userName = 'User_Id1234';
  String _memberSince = '15 Feb, 2025';
  List<Map<String, dynamic>> _weeklyMoods = [];
  List<Map<String, dynamic>> _recentAchievements = [];
  Map<String, dynamic>? _allAchievements;
  bool _isLoadingMoods = false;
  bool _isLoadingAchievements = false;
  bool _isLoadingAllAchievements = false;
  String? _cachedImageBase64;
  Uint8List? _cachedImageBytes;
  bool _isUploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Listen to tab changes to update UI
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
        setState(() {});
      }
    });
    
    // Set status bar to match header color (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _initializeData();
  }

  @override
  void dispose() {
    // Reset status bar when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Get steps and mood from widget or fetch
    _currentSteps = widget.currentSteps ?? 0;
    _currentMood = widget.currentMood ?? 'Happy';
    
    // Initialize step counter if steps not provided
    if (widget.currentSteps == null) {
      final stepCounterInitialized = await _stepCounterService.initialize();
      if (stepCounterInitialized) {
        setState(() {
          _currentSteps = _stepCounterService.getCurrentSteps();
        });
      }
    }

    // Load mood from API if not provided
    if (widget.currentMood == null) {
      final token = await AuthCacheService.getAuthToken();
      final moodData = await MoodApiService.getCurrentMood(token: token);
      if (moodData != null) {
        setState(() {
          _currentMood = moodData['mood'] ?? 'Happy';
        });
      }
    }

    // Load user data
    final userData = await AuthCacheService.getUserData();
    if (userData['name'] != null) {
      setState(() {
        _userName = userData['name']!;
      });
    }

    // Load weekly moods
    _loadWeeklyMoods();

    // Load recent achievements
    _loadRecentAchievements();

    // Load cached image
    _loadCachedImage();

    // Load all achievements when achievements tab is selected
    _tabController.addListener(() {
      if (_tabController.index == 1 && _allAchievements == null) {
        _loadAllAchievements();
      }
    });
  }

  Future<void> _loadCachedImage() async {
    final cachedImage = await AuthCacheService.getUserImage();
    if (mounted && cachedImage != null && cachedImage != _cachedImageBase64) {
      setState(() {
        _cachedImageBase64 = cachedImage;
        // Decode once and cache the bytes to avoid re-decoding on every rebuild
        try {
          final imageData = cachedImage.contains(',')
              ? cachedImage.split(',')[1]
              : cachedImage;
          _cachedImageBytes = base64Decode(imageData);
        } catch (e) {
          _cachedImageBytes = null;
        }
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Request permission first (image_picker handles this automatically, but we check first)
      if (Platform.isAndroid) {
        // Check and request photos permission for Android 13+
        if (!await Permission.photos.isGranted) {
          final status = await Permission.photos.request();
          if (!status.isGranted) {
            // Fallback to storage permission for older Android
            if (!await Permission.storage.isGranted) {
              final storageStatus = await Permission.storage.request();
              if (!storageStatus.isGranted) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permission denied. Please grant photo access in settings.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                return;
              }
            }
          }
        }
      } else if (Platform.isIOS) {
        // For iOS
        if (!await Permission.photos.isGranted) {
          final status = await Permission.photos.request();
          if (!status.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permission denied. Please grant photo access in settings.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            return;
          }
        }
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      // Read image as bytes and convert to base64
      final File imageFile = File(pickedFile.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final String base64String = 'data:image/jpeg;base64,$base64Image';

      setState(() {
        _isUploadingImage = true;
        _cachedImageBase64 = base64String;
        // Cache the decoded bytes immediately
        try {
          _cachedImageBytes = base64Decode(base64Image);
        } catch (e) {
          _cachedImageBytes = null;
        }
      });

      // Try to upload to API
      final token = await AuthCacheService.getAuthToken();
      final success = await UserProfileApiService.updateUserImage(
        token: token ?? '',
        base64Image: base64Image,
      );

      if (success) {
        // If upload succeeds, save to cache
        await AuthCacheService.saveUserImage(base64String);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image updated successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // If upload fails, save to cache anyway
        await AuthCacheService.saveUserImage(base64String);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image saved locally. Upload will retry later.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _loadWeeklyMoods() async {
    setState(() {
      _isLoadingMoods = true;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      final moods = await WeeklyMoodsApiService.getWeeklyMoods(token: token ?? '');
      
      if (mounted) {
        setState(() {
          _weeklyMoods = moods ?? [];
          _isLoadingMoods = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMoods = false;
        });
      }
    }
  }

  Future<void> _loadRecentAchievements() async {
    setState(() {
      _isLoadingAchievements = true;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      final achievements = await AchievementsApiService.getRecentAchievements(
        token: token ?? '',
        limit: 5,
      );
      
      if (mounted) {
        setState(() {
          _recentAchievements = achievements ?? [];
          _isLoadingAchievements = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAchievements = false;
        });
      }
    }
  }

  Future<void> _loadAllAchievements() async {
    setState(() {
      _isLoadingAllAchievements = true;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      final achievements = await AchievementsApiService.getAllAchievements(
        token: token ?? '',
      );
      
      if (mounted) {
        setState(() {
          _allAchievements = achievements;
          _isLoadingAllAchievements = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAllAchievements = false;
        });
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '??';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildHeader(localizations, statusBarHeight),
            _buildTabs(localizations),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(localizations, bottomPadding),
                  _buildAchievementsTab(localizations, bottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, double statusBarHeight) {
    return Container(
      width: double.infinity,
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
        top: statusBarHeight + 16,
        bottom: 20,
      ),
      child: Column(
        children: [
          // Navigation bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                localizations.profile,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(locale: widget.locale),
                    ),
                  );
                },
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
                    Icons.settings,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Avatar with image picker
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.icyWhite,
                  ),
                  child: _cachedImageBytes != null
                      ? ClipOval(
                          child: Image.memory(
                            _cachedImageBytes!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  _getInitials(_userName),
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            _getInitials(_userName),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                ),
                if (_isUploadingImage)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentTeal,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Username
          Text(
            _userName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          // Member since
          Text(
            '${localizations.memberSince} $_memberSince',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(AppLocalizations localizations) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.icyWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _tabController.index == 0
                        ? AppColors.softAqua
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    localizations.overview,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: _tabController.index == 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _tabController.animateTo(1);
                  if (_allAchievements == null) {
                    _loadAllAchievements();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _tabController.index == 1
                        ? AppColors.softAqua
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    localizations.achievements,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: _tabController.index == 1
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(AppLocalizations localizations, double bottomPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding > 0 ? bottomPadding : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Steps and Mood Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: localizations.steps,
                  value: _currentSteps.toString(),
                  icon: Icons.directions_walk_outlined,
                  iconColor: AppColors.accentTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMoodCard(localizations),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // This Week Mode
          Text(
            localizations.thisWeekMode,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildWeeklyMoods(localizations),
          const SizedBox(height: 24),
          // Recent Achievements
          Text(
            localizations.recentAchievements,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentAchievements(localizations),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(icon, color: iconColor, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.accentTeal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(AppLocalizations localizations) {
    final moodImagePath = MoodHelper.getMoodImagePath(_currentMood);
    final moodColor = MoodHelper.getMoodColor(_currentMood);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.mood,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Image.asset(
                'assets/images/home_directory/nav_mood.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.emoji_emotions_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: moodImagePath != null
                ? Image.asset(
                    moodImagePath,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_emotions_outlined,
                        size: 48,
                        color: moodColor,
                      );
                    },
                  )
                : Icon(
                    Icons.emoji_emotions_outlined,
                    size: 48,
                    color: moodColor,
                  ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              _currentMood,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMoods(AppLocalizations localizations) {
    if (_isLoadingMoods) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.accentTeal),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weeklyMoods.map((moodData) {
        final mood = moodData['mood']?.toString() ?? 'Happy';
        final day = moodData['day']?.toString() ?? 'Mo';
        final dayNumber = moodData['dayNumber']?.toString() ?? '1';
        final moodImagePath = MoodHelper.getMoodImagePath(mood);
        final moodColor = MoodHelper.getMoodColor(mood);

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: _weeklyMoods.indexOf(moodData) < _weeklyMoods.length - 1 ? 4 : 0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorShadow,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  day,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  dayNumber,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                moodImagePath != null
                    ? Image.asset(
                        moodImagePath,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.emoji_emotions_outlined,
                            size: 32,
                            color: moodColor,
                          );
                        },
                      )
                    : Icon(
                        Icons.emoji_emotions_outlined,
                        size: 32,
                        color: moodColor,
                      ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentAchievements(AppLocalizations localizations) {
    if (_isLoadingAchievements) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.accentTeal),
        ),
      );
    }

    if (_recentAchievements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            localizations.noAchievementsYet,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _recentAchievements.map((achievement) {
        return _buildAchievementCard(achievement);
      }).toList(),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final title = achievement['title']?.toString() ?? '';
    final description = achievement['description']?.toString() ?? '';
    final unlocked = achievement['unlocked'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Achievement icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: unlocked ? AppColors.softAqua : AppColors.icyWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              unlocked ? Icons.star : Icons.star_border,
              color: unlocked ? AppColors.accentTeal : AppColors.textSecondary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Achievement details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(AppLocalizations localizations, double bottomPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding > 0 ? bottomPadding : 16),
      child: Column(
        children: [
          if (_isLoadingAllAchievements)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: AppColors.accentTeal),
              ),
            )
          else if (_allAchievements == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  localizations.loadingAchievements,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else ...[
            // Achievement summary
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: AppColors.accentTeal,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.yourAchievements,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_allAchievements!['unlocked'] ?? 0} of ${_allAchievements!['total'] ?? 0} ${localizations.unlocked}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_allAchievements!['unlocked'] ?? 0) / (_allAchievements!['total'] ?? 1),
                      minHeight: 8,
                      backgroundColor: AppColors.icyWhite,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentTeal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // All achievements list
            ...((_allAchievements!['achievements'] as List?) ?? []).map((achievement) {
              return _buildAchievementCard(achievement);
            }).toList(),
          ],
        ],
      ),
    );
  }
}
