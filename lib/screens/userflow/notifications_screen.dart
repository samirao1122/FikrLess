import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import '../../utils/time_formatter.dart';

class NotificationsScreen extends StatefulWidget {
  final Locale locale;

  const NotificationsScreen({super.key, required this.locale});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _useDummyData = false;

  @override
  void initState() {
    super.initState();
    // Set status bar to match header color (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    _loadNotifications();
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
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) {
        _loadDummyNotifications();
        return;
      }

      final notifications = await NotificationsApiService.getNotifications(
        token: token,
        limit: 50,
        offset: 1,
      );

      if (notifications != null && notifications.isNotEmpty) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
          _useDummyData = false;
        });
        // Mark all as read when opening screen
        _markAllAsRead();
      } else {
        // If API fails, use dummy data
        _loadDummyNotifications();
      }
    } catch (e) {
      print('Error loading notifications: $e');
      _loadDummyNotifications();
    }
  }

  void _loadDummyNotifications() {
    setState(() {
      _notifications = _getDummyNotifications();
      _isLoading = false;
      _useDummyData = true;
    });
  }

  Future<void> _markAllAsRead() async {
    if (_useDummyData) return;

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) return;

      final unreadIds = _notifications
          .where((n) => n['is_read'] != true)
          .map((n) => n['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      if (unreadIds.isNotEmpty) {
        await NotificationsApiService.markAsRead(
          token: token,
          ids: unreadIds,
        );
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  Future<void> _deleteAllNotifications() async {
    if (_useDummyData) {
      setState(() {
        _notifications = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.notificationsCleared)),
        );
      }
      return;
    }

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) return;

      final allIds = _notifications
          .map((n) => n['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      if (allIds.isNotEmpty) {
        final success = await NotificationsApiService.deleteNotifications(
          token: token,
          ids: allIds,
        );

        if (success && mounted) {
          setState(() {
            _notifications = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.notificationsCleared)),
          );
        }
      }
    } catch (e) {
      print('Error deleting notifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred)),
        );
      }
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.mark_email_unread, color: AppColors.textPrimary),
              title: Text(
                AppLocalizations.of(context)!.markAsUnread,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement mark as unread
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.errorRed),
              title: Text(
                AppLocalizations.of(context)!.clearAll,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.errorRed,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.deleteNotifications,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteNotificationsConfirm,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllNotifications();
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: GoogleFonts.poppins(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyNotifications() {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'title': 'Free Online Session',
        'description': 'That\'s quite common. Let\'s work on building your confidence step by step.',
        'timestamp': now.subtract(Duration(days: 1)).toIso8601String(),
        'sender_name': 'Dr. Omar Rahman',
        'is_read': false,
      },
      {
        'id': '2',
        'title': 'Introductory Webinar',
        'description': 'A great start for beginners to understand the basics.',
        'timestamp': now.subtract(Duration(days: 4)).toIso8601String(),
        'sender_name': 'Bilal Usman',
        'is_read': false,
      },
      {
        'id': '3',
        'title': 'Hands-on Training',
        'description': 'Practice with experienced mentors at your side.',
        'timestamp': now.subtract(Duration(days: 5)).toIso8601String(),
        'sender_name': 'Omar Rahman',
        'is_read': false,
      },
      {
        'id': '4',
        'title': 'Expert Panel Discussion',
        'description': 'Join industry leaders as they share their insights.',
        'timestamp': now.subtract(Duration(days: 6)).toIso8601String(),
        'sender_name': 'Tariq Hassan',
        'is_read': false,
      },
      {
        'id': '5',
        'title': 'Networking Event',
        'description': 'Connect with peers and professionals in your field.',
        'timestamp': now.subtract(Duration(days: 7)).toIso8601String(),
        'sender_name': 'Ahmed Latif',
        'is_read': false,
      },
      {
        'id': '6',
        'title': 'Networking Event',
        'description': 'Connect with peers and professionals in your field.',
        'timestamp': now.subtract(Duration(days: 7)).toIso8601String(),
        'sender_name': 'Ahmed Latif',
        'is_read': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // let header paint behind status bar
        bottom: true,
        child: Column(
          children: [
            _buildHeader(localizations),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentTeal,
                      ),
                    )
                  : _notifications.isEmpty
                      ? _buildEmptyState(localizations)
                      : _buildNotificationsList(localizations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: statusBarHeight + 120, // covers status bar + header
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
        top: statusBarHeight + 16, // content starts below status bar
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              // Back Button
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
              // Title - Centered
              Text(
                localizations.notifications,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              // Menu Button
              GestureDetector(
                onTap: _showOptionsMenu,
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
                    Icons.more_vert,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            localizations.noNotificationsYet,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(AppLocalizations localizations) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final title = notification['title']?.toString() ?? '';
    final description = notification['description']?.toString() ?? '';
    final timestamp = notification['timestamp']?.toString() ?? 
                     notification['created_at']?.toString() ?? 
                     notification['date']?.toString() ?? '';
    final senderName = notification['sender_name']?.toString() ?? 
                      notification['sender']?.toString() ?? 
                      'Unknown';
    final initials = TimeFormatter.getInitials(senderName);
    final timeAgo = TimeFormatter.formatRelativeTime(timestamp);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with initials
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.icyWhite,
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Content
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
                SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          // Timestamp
          Text(
            timeAgo,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
