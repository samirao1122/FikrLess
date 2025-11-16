import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/step_counter_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import '../../utils/mood_helper.dart';
import 'mood_tracking_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'goal_screen.dart';
import 'journal_screen.dart';
import 'specialist_screen.dart';
import 'exercise_screen.dart';
import 'article_screen.dart';
import 'forum_screen.dart';
import 'chat_screen.dart';
import 'wellness_screen.dart';
import 'spiritual_hub_screen.dart';

class HomeScreen extends StatefulWidget {
  final Locale locale;

  const HomeScreen({super.key, required this.locale});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StepCounterService _stepCounterService = StepCounterService();
  int _currentSteps = 0;
  String _currentMood = 'Happy';
  String _quoteText = 'And whoever relies upon Allah – then He is sufficient for him.';
  String _quoteSource = '(Qur\'an 65:3)';
  bool _isLoadingQuote = false;
  bool _isLoadingMood = false;
  int _selectedIndex = 0;
  String? _cachedImageBase64;
  Uint8List? _cachedImageBytes;

  @override
  void initState() {
    super.initState();
    // Hide system status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize step counter
    final stepCounterInitialized = await _stepCounterService.initialize();
    if (stepCounterInitialized) {
      _updateSteps();
      // Update steps every second
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateSteps();
        } else {
          timer.cancel();
        }
      });
    }

    // Load mood from API
    _loadMood();

    // Load quote from API
    _loadQuote();

    // Load cached image
    _loadCachedImage();
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

  void _updateSteps() {
    setState(() {
      _currentSteps = _stepCounterService.getCurrentSteps();
    });
  }

  Future<void> _loadMood() async {
    setState(() {
      _isLoadingMood = true;
    });

    // Get token from cache
    final token = await AuthCacheService.getAuthToken();
    final moodData = await MoodApiService.getCurrentMood(token: token);

    if (mounted) {
      setState(() {
        _isLoadingMood = false;
        if (moodData != null) {
          _currentMood = moodData['mood'] ?? 'Happy';
        }
      });
    }
  }

  Future<void> _loadQuote() async {
    setState(() {
      _isLoadingQuote = true;
    });

    // Get token from cache
    final token = await AuthCacheService.getAuthToken();
    final quoteData = await QuoteApiService.getQuoteOfTheDay(token: token);

    if (mounted) {
      setState(() {
        _isLoadingQuote = false;
        if (quoteData != null) {
          _quoteText = quoteData['text'] ?? _quoteText;
          _quoteSource = quoteData['source'] ?? _quoteSource;
        }
      });
    }
  }

  @override
  void dispose() {
    _stepCounterService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Build screens list - 5 screens for bottom navigation (Chat in center)
    final screens = [
      _buildHomeContent(),
      ArticleScreen(locale: widget.locale),
      ChatScreen(locale: widget.locale), // Chat in center (index 2)
      ForumScreen(locale: widget.locale),
      WellnessScreen(locale: widget.locale),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // Don't add padding for system status bar
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(localizations),
    );
  }

  Widget _buildHomeContent() {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with teal background
          _buildHeader(localizations),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // My Activity Section
                _buildMyActivitySection(localizations),
                const SizedBox(height: 24),
                
                // Quick Actions Section
                _buildQuickActionsSection(localizations),
                const SizedBox(height: 24),
                
                // Quote of the Day Section
                _buildQuoteSection(localizations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      height: 140, // Fixed height so we can position content at the bottom
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15), // 10dp above bottom
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ---- Left: Profile ----
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        locale: widget.locale,
                        currentSteps: _currentSteps,
                        currentMood: _currentMood,
                      ),
                    ),
                  );
                  // Reload cached image after returning from profile screen
                  _loadCachedImage();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4), // space from circle edge
                    child: _cachedImageBytes != null
                        ? ClipOval(
                            child: Image.memory(
                              _cachedImageBytes!,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: AppColors.accentTeal,
                                  size: 24,
                                );
                              },
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'assets/images/home_directory/com_helper.png',
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: AppColors.accentTeal,
                                  size: 24,
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),

              // ---- Right: Notification ----
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NotificationsScreen(locale: widget.locale),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/home_directory/notifications_image.png',
                      width: 24,
                      height: 24,
                      color: AppColors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.white,
                          size: 24,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyActivitySection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.myActivity,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to activity details screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Activity details coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                localizations.seeMore,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                title: localizations.steps,
                value: _currentSteps.toString(),
                icon: Icons.directions_walk_outlined,
                iconColor: AppColors.accentTeal,
                onTap: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                title: localizations.mood,
                value: _currentMood,
                icon: Icons.emoji_emotions_outlined,
                iconColor: AppColors.textPrimary,
                moodName: _isLoadingMood ? null : _currentMood,
                isMood: true,
                isLoading: _isLoadingMood,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoodTrackingScreen(locale: widget.locale),
                    ),
                  ).then((_) {
                    // Reload mood after selection
                    _loadMood();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    String? moodName,
    VoidCallback? onTap,
    bool isMood = false,
    bool isLoading = false,
  }) {
    final isMoodCard = moodName != null && !isLoading;
    final moodImagePath = isMoodCard ? MoodHelper.getMoodImagePath(moodName) : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Fixed height to ensure same size
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
                // Use mood icon asset if it's a mood card, otherwise use icon
                isMood
                    ? Image.asset(
                        'assets/images/home_directory/nav_mood.png',
                        width: 24,
                        height: 24,
                        color: iconColor,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            icon,
                            color: iconColor,
                            size: 24,
                          );
                        },
                      )
                    : Icon(
                        icon,
                        color: iconColor,
                        size: 24,
                      ),
              ],
            ),
            const Spacer(),
            Center(
              child: isLoading && isMood
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentTeal),
                      ),
                    )
                  : isMoodCard && moodImagePath != null
                      ? Image.asset(
                          moodImagePath,
                          width: 48,
                          height: 48,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image not found
                            return Icon(
                              icon,
                              size: 48,
                              color: AppColors.textSecondary,
                            );
                          },
                        )
                      : Text(
                          value,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentTeal,
                          ),
                        ),
            ),
            const Spacer(),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isLoading && isMood ? title : (isMoodCard ? value : title),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.quickActions,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickActionButton(
                icon: Icons.flag_outlined,
                label: localizations.goal,
                iconBgColor: AppColors.icyWhite,
                imageAsset: 'assets/images/home_directory/goals.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoalScreen(locale: widget.locale),
                    ),
                  );
                },
              ),
              _buildQuickActionButton(
                icon: Icons.book_outlined,
                label: localizations.journal,
                iconBgColor: AppColors.icyWhite,
                imageAsset: 'assets/images/home_directory/journal.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JournalScreen(locale: widget.locale),
                    ),
                  );
                },
              ),
              _buildQuickActionButton(
                icon: Icons.person_outline,
                label: localizations.specialist,
                iconBgColor: AppColors.icyWhite,
                imageAsset: 'assets/images/home_directory/specialist.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpecialistScreen(locale: widget.locale),
                    ),
                  );
                },
              ),
              _buildQuickActionButton(
                icon: Icons.favorite_outline,
                label: localizations.exercise,
                iconBgColor: AppColors.icyWhite,
                imageAsset: 'assets/images/home_directory/exercise.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(locale: widget.locale),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color iconBgColor,
    required VoidCallback onTap,
    String? imageAsset,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageAsset,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          icon,
                          color: AppColors.accentTeal,
                          size: 28,
                        );
                      },
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.accentTeal,
                    size: 28,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteSection(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.quoteOfTheDay,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpiritualHubScreen(locale: widget.locale),
                    ),
                  );
                },
                child: Text(
                  localizations.seeMore,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingQuote)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  localizations.loadingQuote,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else ...[
            Text(
              _quoteText,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _quoteSource,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.accentTeal,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/home_directory/nav_home.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0 ? AppColors.accentTeal : AppColors.textSecondary,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                      color: _selectedIndex == 0 ? AppColors.accentTeal : AppColors.textSecondary,
                    );
                  },
                ),
                if (_selectedIndex == 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.favorite,
                      size: 10,
                      color: AppColors.accentTeal,
                    ),
                  ),
              ],
            ),
            label: localizations.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_directory/nav_article.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? AppColors.accentTeal : AppColors.textSecondary,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _selectedIndex == 1 ? Icons.article : Icons.article_outlined,
                  color: _selectedIndex == 1 ? AppColors.accentTeal : AppColors.textSecondary,
                );
              },
            ),
            label: localizations.article,
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentTeal,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/home_directory/nav_chat.png',
                  width: 24,
                  height: 24,
                  color: AppColors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.chat_bubble,
                      color: AppColors.white,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            label: localizations.chat,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_directory/nav_forum.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? AppColors.accentTeal : AppColors.textSecondary,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _selectedIndex == 3 ? Icons.forum : Icons.forum_outlined,
                  color: _selectedIndex == 3 ? AppColors.accentTeal : AppColors.textSecondary,
                );
              },
            ),
            label: localizations.forum,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_directory/nav_wellness.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 4 ? AppColors.accentTeal : AppColors.textSecondary,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _selectedIndex == 4 ? Icons.favorite : Icons.favorite_outline,
                  color: _selectedIndex == 4 ? AppColors.accentTeal : AppColors.textSecondary,
                );
              },
            ),
            label: localizations.wellness,
          ),
        ],
      ),
    );
  }
}

