import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_cache_service.dart';
import '../../../utils/time_formatter.dart';

class NotificationsScreen extends StatefulWidget {
  final Locale locale;

  const NotificationsScreen({super.key, required this.locale});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _useDummyData = false;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(_onScroll);
    _loadNotifications();
  }

  void _onScroll() {
    // Load more when user scrolls near the bottom (standard pagination)
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200 && 
        !_isLoadingMore && 
        _hasMore && 
        !_useDummyData) {
      _loadMoreNotifications();
    }
  }

  @override
  void dispose() {
    // Remove scroll listener and dispose controller
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    
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

  Future<void> _loadNotifications({bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _hasMore = true;
      });
    }

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) {
        _loadDummyNotifications();
        return;
      }

      final result = await NotificationsApiService.getNotifications(
        token: token,
        limit: 20,
        page: _currentPage,
        status: 'all',
      );

      if (result != null && result['success'] == true && result['data'] != null) {
        final rawNotifications = (result['data'] as List).cast<Map<String, dynamic>>();
        
        // Map API response to display format
        final mappedNotifications = rawNotifications.map((notification) {
          final payload = notification['payload'] as Map<String, dynamic>? ?? {};
          return {
            '_id': notification['_id'] ?? '',
            'title': payload['title'] ?? '',
            'description': payload['body'] ?? '',
            'timestamp': notification['createdAt'] ?? '',
            'type': payload['type'] ?? '',
            'status': notification['status'] ?? 'unread',
            'read_at': notification['read_at'],
            'payload': payload,
            'is_read': notification['status'] == 'read' || notification['read_at'] != null,
            // For display purposes
            'sender_name': payload['metadata']?['category'] ?? 'System',
          };
        }).toList();

        // Update pagination info
        final pagination = result['pagination'] as Map<String, dynamic>? ?? {};
        final totalPages = pagination['total_pages'] as int? ?? 1;
        final currentPage = pagination['page'] as int? ?? 1;

        setState(() {
          if (reset) {
            _notifications = mappedNotifications;
          } else {
            // Append older notifications (standard pagination)
            _notifications = [..._notifications, ...mappedNotifications];
          }
          _currentPage = currentPage;
          _totalPages = totalPages;
          _hasMore = currentPage < totalPages;
          _isLoading = false;
          _isLoadingMore = false;
          _useDummyData = false;
        });

        // Mark all as read when opening screen (only on initial load)
        if (reset) {
          _markAllAsRead();
        }
      } else {
        // If API fails, use dummy data
        if (reset) {
          _loadDummyNotifications();
        }
      }
    } catch (e) {
      print('Error loading notifications: $e');
      if (reset) {
        _loadDummyNotifications();
      } else {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMore || _useDummyData) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage = _currentPage + 1;
    });

    await _loadNotifications(reset: false);
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

      // Mark all as read using the new API
      await NotificationsApiService.markAllRead(token: token);
      
      // Update local state
      if (mounted) {
        setState(() {
          _notifications = _notifications.map((notif) {
            return {
              ...notif,
              'status': 'read',
              'is_read': true,
              'read_at': DateTime.now().toIso8601String(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    if (_useDummyData) return;

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) return;

      await NotificationsApiService.updateNotificationStatus(
        notificationId: notificationId,
        status: 'read',
        token: token,
      );
      
      // Update local state
      if (mounted) {
        setState(() {
          _notifications = _notifications.map((notif) {
            if (notif['_id'] == notificationId) {
              return {
                ...notif,
                'status': 'read',
                'is_read': true,
                'read_at': DateTime.now().toIso8601String(),
              };
            }
            return notif;
          }).toList();
        });
      }
    } catch (e) {
      print('Error marking notification as read: $e');
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

      // Clear all notifications using the new API
      final success = await NotificationsApiService.clearAllNotifications(token: token);

      if (success && mounted) {
        setState(() {
          _notifications = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.notificationsCleared)),
        );
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
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Mark as Unread option
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Icon(Icons.mark_email_unread, color: AppColors.textPrimary, size: 24),
                title: Text(
                  AppLocalizations.of(context)!.markAsUnread,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement mark as unread
                },
              ),
              // Divider
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                indent: 24,
                endIndent: 24,
              ),
              // Clear All option
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Icon(Icons.delete_outline, color: AppColors.errorRed, size: 24),
                title: Text(
                  AppLocalizations.of(context)!.clearAll,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.errorRed,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              ),
              // Bottom padding
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
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
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: _notifications.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom when loading more
        if (index == _notifications.length && _isLoadingMore) {
          return Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: AppColors.accentTeal,
            ),
          );
        }
        
        if (index >= _notifications.length) {
          return SizedBox.shrink();
        }
        
        final notification = _notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    // Support both API format and dummy data format
    final title = notification['title']?.toString() ?? 
                  notification['payload']?['title']?.toString() ?? '';
    final description = notification['description']?.toString() ?? 
                        notification['payload']?['body']?.toString() ?? '';
    final timestamp = notification['timestamp']?.toString() ?? 
                     notification['createdAt']?.toString() ?? 
                     notification['created_at']?.toString() ?? 
                     notification['date']?.toString() ?? '';
    final senderName = notification['sender_name']?.toString() ?? 
                      notification['payload']?['metadata']?['category']?.toString() ??
                      'System';
    final timeAgo = TimeFormatter.formatRelativeTime(timestamp);
    final initials = TimeFormatter.getInitials(senderName);
    
    // Mark as read when viewing details
    if (!_useDummyData && notification['_id'] != null) {
      _markNotificationAsRead(notification['_id']);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and sender name
              Row(
                children: [
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // Full description with scroll
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    description.isEmpty ? 'No description available' : description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentTeal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    // Support both API format and dummy data format
    final title = notification['title']?.toString() ?? 
                  notification['payload']?['title']?.toString() ?? '';
    final description = notification['description']?.toString() ?? 
                        notification['payload']?['body']?.toString() ?? '';
    final timestamp = notification['timestamp']?.toString() ?? 
                     notification['createdAt']?.toString() ?? 
                     notification['created_at']?.toString() ?? 
                     notification['date']?.toString() ?? '';
    final senderName = notification['sender_name']?.toString() ?? 
                      notification['payload']?['metadata']?['category']?.toString() ??
                      'System';
    final isRead = notification['is_read'] == true || 
                   notification['status'] == 'read' ||
                   notification['read_at'] != null;
    final initials = TimeFormatter.getInitials(senderName);
    final timeAgo = TimeFormatter.formatRelativeTime(timestamp);

    return GestureDetector(
      onTap: () => _showNotificationDetails(notification),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isRead ? null : Border.all(
            color: AppColors.accentTeal.withValues(alpha: 0.3),
            width: 1,
          ),
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
      ),
    );
  }
}
