import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_cache_service.dart';
import '../../../services/api_service.dart';
import '../../userflow/notifications/notifications_screen.dart';
import '../../userflow/social/article_screen.dart';
import '../../userflow/social/chat_screen.dart';
import '../profile/specialist_profile_screen.dart';

class SpecialistDashboardScreen extends StatefulWidget {
  final Locale locale;
  static final GlobalKey<State<SpecialistDashboardScreen>> navigatorKey = GlobalKey<State<SpecialistDashboardScreen>>();

  SpecialistDashboardScreen({required this.locale}) : super(key: navigatorKey);

  @override
  State<SpecialistDashboardScreen> createState() => _SpecialistDashboardScreenState();

  /// Navigate to a specific tab (0 = Dashboard, 1 = Article, 2 = Chat, 3 = Sessions, 4 = Settings)
  static void navigateToTab(int index) {
    final state = navigatorKey.currentState;
    if (state != null && state.mounted && state is _SpecialistDashboardScreenState) {
      (state as _SpecialistDashboardScreenState)._navigateToTab(index);
    }
  }
}

class _SpecialistDashboardScreenState extends State<SpecialistDashboardScreen> {
  int _selectedIndex = 0;
  String? _cachedImageBase64;
  Uint8List? _cachedImageBytes;
  int _unreadNotificationCount = 0;
  
  // Dummy data for now
  final String _totalEarnings = "PKR 45K";
  final int _upcomingSessions = 5;
  
  final List<Map<String, dynamic>> _todayAppointments = [
    {
      'title': 'Initial Consultation',
      'time': '09:00',
      'duration': '15 mins',
    },
    {
      'title': 'Crisis Support',
      'time': '09:15',
      'duration': '30 mins',
    },
    {
      'title': 'Feedback Session',
      'time': '09:45',
      'duration': '20 mins',
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initializeServices();
    _loadCachedImage();
    _loadUnreadNotificationCount();
    
    // Refresh unread count periodically
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _loadUnreadNotificationCount();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _initializeServices() async {
    // Print user ID and token for debugging
    final userId = await AuthCacheService.getUserId();
    final token = await AuthCacheService.getAuthToken();
    
    print('═══════════════════════════════════════════════════════════');
    print('👤 SPECIALIST DASHBOARD - USER INFO:');
    if (userId != null) {
      print('🔑 USER ID: $userId');
    } else {
      print('⚠️ User ID not found in cache');
    }
    if (token != null) {
      print('🔐 TOKEN: $token');
    } else {
      print('⚠️ Token not found in cache');
    }
    print('═══════════════════════════════════════════════════════════');
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) return;

      final count = await NotificationsApiService.getUnreadCount(token: token);
      if (mounted) {
        setState(() {
          _unreadNotificationCount = count ?? 0;
        });
      }
    } catch (e) {
      print('Error loading unread notification count: $e');
    }
  }

  Future<void> _loadCachedImage() async {
    final cachedImage = await AuthCacheService.getUserImage();
    if (mounted && cachedImage != null && cachedImage != _cachedImageBase64) {
      setState(() {
        _cachedImageBase64 = cachedImage;
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

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '??';
  }

  void _navigateToTab(int index) {
    if (mounted && index >= 0 && index < 4) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Get current locale from app state (updates when language changes)
    final currentLocale = Localizations.localeOf(context);

    // Build screens list for bottom navigation
    final screens = [
      _buildDashboardContent(),
      ArticleScreen(locale: currentLocale),
      ChatScreen(locale: currentLocale),
      _buildSessionsScreen(), // Placeholder for sessions screen
    ];

    return Localizations.override(
      context: context,
      locale: currentLocale,
      child: Directionality(
        textDirection: currentLocale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: screens,
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(localizations),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
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
                // Overview Section
                _buildOverviewSection(localizations),
                const SizedBox(height: 24),
                
                // Today's Appointments Section
                _buildAppointmentsSection(localizations),
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
      height: 140,
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
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Profile
              GestureDetector(
                onTap: () async {
                  final currentLocale = Localizations.localeOf(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpecialistProfileScreen(locale: currentLocale),
                    ),
                  );
                  // Refresh profile image after returning
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
                    padding: const EdgeInsets.all(4),
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

              // Right: Notification
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(locale: widget.locale),
                    ),
                  );
                  // Refresh unread count after returning from notifications screen
                  _loadUnreadNotificationCount();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
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
                    // Unread count badge
                    if (_unreadNotificationCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              _unreadNotificationCount > 99 ? '99+' : '$_unreadNotificationCount',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
    );
  }

  Widget _buildOverviewSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.overview,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                title: localizations.wallet,
                value: _totalEarnings,
                subtitle: localizations.totalEarnings,
                icon: Icons.account_balance_wallet_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                title: localizations.sessions,
                value: _upcomingSessions.toString(),
                subtitle: localizations.upcoming,
                icon: Icons.calendar_today_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
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
              Icon(
                icon,
                color: AppColors.accentTeal,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.accentTeal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.todaysAppointments,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to all appointments
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.viewAll),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                localizations.viewAll,
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
        ..._todayAppointments.map((appointment) {
          final title = appointment['title'] as String;
          String localizedTitle = title;
          final loc = AppLocalizations.of(context);
          if (loc != null) {
            switch (title) {
              case 'Initial Consultation':
                localizedTitle = loc.initialConsultation;
                break;
              case 'Crisis Support':
                localizedTitle = loc.crisisSupport;
                break;
              case 'Feedback Session':
                localizedTitle = loc.feedbackSession;
                break;
            }
          }
          return _buildAppointmentCard(
            title: localizedTitle,
            time: appointment['time'] as String,
            duration: appointment['duration'] as String,
          );
        }),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required String title,
    required String time,
    required String duration,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Calendar icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.icyWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home_directory/nav_sessions.png',
                width: 24,
                height: 24,
                color: AppColors.accentTeal,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.calendar_today,
                    color: AppColors.accentTeal,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Appointment details
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
                  '$time ($duration)',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // View button
          OutlinedButton(
            onPressed: () {
              // TODO: Show appointment details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('View details for $title'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accentTeal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.view ?? 'View',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsScreen() {
    final localizations = AppLocalizations.of(context);
    return Center(
      child: Text(
        '${localizations?.sessions ?? 'Sessions'} Screen',
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
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
                  'assets/images/home_directory/nav_dashboard.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0 ? AppColors.accentTeal : AppColors.textSecondary,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _selectedIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                      color: _selectedIndex == 0 ? AppColors.accentTeal : AppColors.textSecondary,
                    );
                  },
                ),
                if (_selectedIndex == 0)
                  const Positioned(
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
            label: localizations.dashboard ?? 'Dashboard',
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
              'assets/images/home_directory/nav_sessions.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? AppColors.accentTeal : AppColors.textSecondary,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _selectedIndex == 3 ? Icons.calendar_today : Icons.calendar_today_outlined,
                  color: _selectedIndex == 3 ? AppColors.accentTeal : AppColors.textSecondary,
                );
              },
            ),
            label: localizations.sessions,
          ),
        ],
      ),
    );
  }
}

