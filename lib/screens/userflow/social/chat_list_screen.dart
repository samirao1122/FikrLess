import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/chat_service.dart';
import '../../../services/auth_cache_service.dart';
import '../../../services/image_cache_service.dart';
import '../../../services/api_service.dart';
import '../dashboard/home_screen.dart';
import '../../specialistflow/dashboard/specialist_dashboard_screen.dart';
import 'individual_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final Locale locale;

  const ChatListScreen({super.key, required this.locale});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AutomaticKeepAliveClientMixin {
  String? _currentUserId;
  StreamSubscription<QuerySnapshot>? _chatRoomsSubscription;
  bool _useFallbackQuery = false; // Track if we should use fallback query
  Stream<QuerySnapshot>? _cachedStream; // Cache the stream to prevent recreation
  
  @override
  bool get wantKeepAlive => true; // Keep state alive in IndexedStack

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _loadUserId();
  }

  @override
  void dispose() {
    _chatRoomsSubscription?.cancel();
    _cachedStream = null; // Clear stream reference
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final userId = await AuthCacheService.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = userId;
      });
      if (userId != null) {
        // Initialize FCM
        ChatService.initializeFCM(userId).catchError((error) {
          print('FCM initialization failed: $error');
        });
        // Initialize stream
        _initializeStream(userId);
      }
    }
  }

  void _initializeStream(String userId) {
    // Start with fallback query to avoid index requirement
    // This prevents flashing/looping issues
    _cachedStream = ChatService.getChatRoomsStreamFallback(userId);
    _useFallbackQuery = true;
  }

  /// Load specialist image from cache or fetch from API
  Future<String?> _loadSpecialistImage(String specialistId) async {
    // Check if widget is still mounted before starting async operations
    if (!mounted) return null;

    // Check if image exists in cache
    try {
      final cachedPath = await ImageCacheService.getImagePath(specialistId);
      if (!mounted) return null; // Check again after async operation
      if (cachedPath != null) {
        return cachedPath;
      }
    } catch (e) {
      print('Error getting cached image path: $e');
      if (!mounted) return null;
    }

    // Fetch from API and cache
    if (!mounted) return null; // Check before making API call
    try {
      final profile = await SpecialistApiService.getSpecialistPublicProfile(
        specialistId: specialistId,
      );

      if (!mounted) return null; // Check after API call completes

      if (profile != null) {
        final basicInfo = profile['basic_info'] as Map<String, dynamic>? ?? profile;
        final profilePhoto = basicInfo['profile_photo'] as String? ?? 
                            profile['profile_photo'] as String?;
        
        if (profilePhoto != null && profilePhoto.isNotEmpty) {
          if (!mounted) return null; // Check before saving
          // Save to file cache
          try {
            final filePath = await ImageCacheService.saveImageFromBase64(
              userId: specialistId,
              base64Image: profilePhoto,
            );
            if (!mounted) return null; // Check after saving
            return filePath;
          } catch (e) {
            print('Error saving image to cache: $e');
            if (!mounted) return null;
          }
        }
      }
    } catch (e) {
      print('Error loading specialist image: $e');
      if (!mounted) return null;
    }

    return null;
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  Widget _buildChatItem(DocumentSnapshot chatRoomDoc) {
    if (!mounted || _currentUserId == null) return const SizedBox.shrink();

    try {
      final data = chatRoomDoc.data() as Map<String, dynamic>?;
      if (data == null) return const SizedBox.shrink();

    final participants = data['participants'] as List? ?? [];
    final otherUserId = participants.firstWhere(
      (id) => id != _currentUserId,
      orElse: () => null,
    );

    if (otherUserId == null) return const SizedBox.shrink();

    final users = data['users'] as Map<String, dynamic>? ?? {};
    final otherUserData = users[otherUserId] as Map<String, dynamic>? ?? {};
    final otherUserName = otherUserData['name'] as String? ?? 'Unknown';
    // Images are no longer stored in Firebase - will fetch from API when needed
    final lastMessage = data['lastMessage'] as String? ?? '';
    final lastMessageTime = data['lastMessageTime'] as Timestamp?;
    final lastMessageSenderId = data['lastMessageSenderId'] as String?;

    // Get unread count
    return FutureBuilder<int>(
      future: ChatService.getUnreadCount(
        userId1: _currentUserId!,
        userId2: otherUserId,
        currentUserId: _currentUserId!,
      ),
      builder: (context, snapshot) {
        if (!mounted) return const SizedBox.shrink();
        final unreadCount = snapshot.data ?? 0;

        // Load image from file cache or fetch from API
        return FutureBuilder<String?>(
          future: _loadSpecialistImage(otherUserId),
          builder: (context, imageSnapshot) {
            if (!mounted) return const SizedBox.shrink();
            
            // Don't build if future is still loading and widget is disposed
            if (imageSnapshot.connectionState == ConnectionState.waiting && !mounted) {
              return const SizedBox.shrink();
            }
            
            final imagePath = imageSnapshot.data;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.colorShadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IndividualChatScreen(
                        locale: widget.locale,
                        specialistId: otherUserId,
                        specialistName: otherUserName,
                        specialistImagePath: imagePath,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.background,
                          ),
                          child: imagePath != null && mounted
                              ? ClipOval(
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      if (!mounted) return const SizedBox.shrink();
                                      return const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.textSecondary,
                                      );
                                    },
                                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                      if (!mounted) return const SizedBox.shrink();
                                      return child;
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                        // Verified badge (you can add logic to check if specialist is verified)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 10,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUserName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTimestamp(lastMessageTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentTeal,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
    } catch (e) {
      print('Error building chat item: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        // Navigate to appropriate dashboard when back is pressed
        final userRole = await AuthCacheService.getUserRole();
        final userType = userRole?.toLowerCase() ?? 'user';
        
        if (mounted) {
          // First, try to switch to home tab in existing dashboard (if we're in a tab)
          // This will work if the dashboard is already in the widget tree
          bool tabSwitched = false;
          if (userType != 'user') {
            final specialistState = SpecialistDashboardScreen.navigatorKey.currentState;
            if (specialistState != null && specialistState.mounted) {
              SpecialistDashboardScreen.navigateToTab(0);
              tabSwitched = true;
            }
          } else {
            final homeState = HomeScreen.navigatorKey.currentState;
            if (homeState != null && homeState.mounted) {
              HomeScreen.navigateToTab(0);
              tabSwitched = true;
            }
          }
          
          // If we successfully switched tabs, we're done
          if (tabSwitched) {
            return false; // Prevent default back behavior
          }
          
          // If we can pop, just pop (we're not at root)
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            return false; // Prevent default back behavior
          }
          
          // We're at root and dashboard doesn't exist - navigate to it
          // Check one more time if dashboard exists before creating
          if (mounted) {
            bool shouldCreate = true;
            if (userType != 'user') {
              final existingState = SpecialistDashboardScreen.navigatorKey.currentState;
              if (existingState != null && existingState.mounted) {
                shouldCreate = false;
                SpecialistDashboardScreen.navigateToTab(0);
              }
            } else {
              final existingState = HomeScreen.navigatorKey.currentState;
              if (existingState != null && existingState.mounted) {
                shouldCreate = false;
                HomeScreen.navigateToTab(0);
              }
            }
            
            // Only create new instance if dashboard truly doesn't exist
            if (shouldCreate) {
              if (userType != 'user') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialistDashboardScreen(locale: widget.locale),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(locale: widget.locale),
                  ),
                );
              }
            }
          }
        }
        
        return false; // Prevent default back behavior (don't close app)
      },
      child: Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.accentTeal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // Removed back button since this is a tab in dashboard
                Expanded(
                  child: Text(
                    'Chat',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.white),
                  onPressed: () {
                    // TODO: Implement search
                  },
                ),
              ],
            ),
          ),
          // Chat List
          Expanded(
            child: _currentUserId == null
                ? const Center(child: CircularProgressIndicator())
                : _buildChatList(),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildChatList() {
    if (_currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ensure stream is initialized
    if (_cachedStream == null) {
      _initializeStream(_currentUserId!);
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _cachedStream,
      builder: (context, snapshot) {
        // Check if widget is still mounted
        if (!mounted) {
          return const SizedBox.shrink();
        }

        // Handle errors gracefully
        if (snapshot.hasError) {
          if (!mounted) return const SizedBox.shrink();
          try {
            return _buildErrorWidget(snapshot.error.toString());
          } catch (e) {
            print('Error building error widget: $e');
            return const Center(
              child: Text('Error loading chats'),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (!mounted) return const SizedBox.shrink();
          return const Center(child: CircularProgressIndicator());
        }

        // Safely check for data
        if (!snapshot.hasData) {
          if (!mounted) return const SizedBox.shrink();
          return _buildEmptyState();
        }

        final data = snapshot.data;
        if (data == null || data.docs.isEmpty) {
          if (!mounted) return const SizedBox.shrink();
          return _buildEmptyState();
        }

        // Sort manually if using fallback query
        try {
          final docs = data.docs;
          final sortedDocs = _useFallbackQuery
              ? (docs.toList()
                ..sort((a, b) {
                  try {
                    final timeA = a.data() as Map<String, dynamic>?;
                    final timeB = b.data() as Map<String, dynamic>?;
                    if (timeA == null || timeB == null) return 0;
                    final timestampA = timeA['lastMessageTime'] as Timestamp?;
                    final timestampB = timeB['lastMessageTime'] as Timestamp?;
                    if (timestampA == null && timestampB == null) return 0;
                    if (timestampA == null) return 1;
                    if (timestampB == null) return -1;
                    return timestampB.compareTo(timestampA);
                  } catch (e) {
                    print('Error sorting chat items: $e');
                    return 0;
                  }
                }))
              : docs;

          if (!mounted) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedDocs.length,
            itemBuilder: (context, index) {
              if (!mounted) {
                return const SizedBox.shrink();
              }
              try {
                if (index >= sortedDocs.length) {
                  return const SizedBox.shrink();
                }
                return _buildChatItem(sortedDocs[index]);
              } catch (e) {
                print('Error building chat item: $e');
                return const SizedBox.shrink();
              }
            },
          );
        } catch (e) {
          print('Error processing chat list: $e');
          if (!mounted) return const SizedBox.shrink();
          return _buildErrorWidget('Error loading chats');
        }
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    final isIndexError = error.contains('index') || error.contains('FAILED_PRECONDITION');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              isIndexError 
                  ? 'Creating index...\nPlease wait a moment'
                  : 'Error loading chats',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (isIndexError) ...[
              const SizedBox(height: 8),
              Text(
                'The chat index is being created.\nThis may take a few minutes.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

