import 'dart:io';
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

enum RestrictedType {
  number,
  link,
  specialChar,
}

class _RestrictedContentInputFormatter extends TextInputFormatter {
  final Function(RestrictedType) onRestrictedContent;

  _RestrictedContentInputFormatter({required this.onRestrictedContent});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;
    
    // Only check the newly added text (difference between old and new)
    final addedText = newText.length > oldText.length 
        ? newText.substring(oldText.length)
        : '';
    
    // Check for numbers in the added text
    if (RegExp(r'\d').hasMatch(addedText)) {
      onRestrictedContent(RestrictedType.number);
      return oldValue; // Reject the change
    }
    
    // Check for links in the new text
    final linkPattern = RegExp(
      r'(https?://|www\.|\.com|\.net|\.org|\.io|\.co|\.edu|\.gov|\.me|\.info|\.biz|\.us|\.uk|\.pk)',
      caseSensitive: false,
    );
    if (linkPattern.hasMatch(newText)) {
      onRestrictedContent(RestrictedType.link);
      return oldValue; // Reject the change
    }
    
    // Check for restricted special characters: / and \ in the added text
    if (addedText.contains('/') || addedText.contains('\\')) {
      onRestrictedContent(RestrictedType.specialChar);
      return oldValue; // Reject the change
    }
    
    return newValue; // Allow the change
  }
}

class IndividualChatScreen extends StatefulWidget {
  final Locale locale;
  final String specialistId;
  final String specialistName;
  final String? specialistImagePath; // File path to cached image
  final String? specialization; // Optional specialization

  const IndividualChatScreen({
    super.key,
    required this.locale,
    required this.specialistId,
    required this.specialistName,
    this.specialistImagePath,
    this.specialization,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;
  String? _currentUserName;
  bool _isSending = false;
  bool _showRestrictionWarning = false;
  Stream<QuerySnapshot>? _messagesStream;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _loadUserData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userId = await AuthCacheService.getUserId();
    final userName = await AuthCacheService.getUserName();
    String? finalUserName = userName;

    if (finalUserName == null || finalUserName.isEmpty) {
      final email = await AuthCacheService.getUserEmail();
      if (email != null && email.isNotEmpty) {
        finalUserName = email.split('@')[0];
      }
    }

    if (!mounted) return;

    setState(() {
      _currentUserId = userId;
      _currentUserName = finalUserName ?? 'User';

      if (userId != null) {
        _messagesStream = ChatService.getMessagesStream(
          userId1: userId,
          userId2: widget.specialistId,
        );
      }
    });

    if (userId != null) {
      await ChatService.markMessagesAsRead(
        userId1: userId,
        userId2: widget.specialistId,
        currentUserId: userId,
      );
    }
  }


  bool _containsRestrictedContent(String text) {
    // Check for numbers (digits)
    if (RegExp(r'\d').hasMatch(text)) {
      return true;
    }
    
    // Check for links (http, https, www, .com, .net, etc.)
    final linkPattern = RegExp(
      r'(https?://|www\.|\.com|\.net|\.org|\.io|\.co|\.edu|\.gov|\.me|\.info|\.biz|\.us|\.uk|\.pk)',
      caseSensitive: false,
    );
    if (linkPattern.hasMatch(text)) {
      return true;
    }
    
    // Check for restricted special characters: / and \
    if (text.contains('/') || text.contains('\\')) {
      return true;
    }
    
    return false;
  }



  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    
    if (messageText.isEmpty || 
        _currentUserId == null || 
        _isSending) {
      return;
    }

    // Validate message before sending (backup check in case formatter was bypassed)
    if (_containsRestrictedContent(messageText)) {
      String errorMessage = 'Message contains restricted content. Please remove numbers, links, or special characters (/, \\)';
      if (RegExp(r'\d').hasMatch(messageText)) {
        errorMessage = 'Numbers are not allowed in messages';
      } else if (RegExp(r'(https?://|www\.|\.com|\.net|\.org|\.io|\.co|\.edu|\.gov|\.me|\.info|\.biz|\.us|\.uk|\.pk)', caseSensitive: false).hasMatch(messageText)) {
        errorMessage = 'Links are not allowed in messages';
      } else if (messageText.contains('/') || messageText.contains('\\')) {
        errorMessage = 'Special characters (/, \\) are not allowed';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.errorRed,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final message = messageText;
    
    setState(() {
      _isSending = true;
    });

    try {
      // Note: Images are not sent to Firebase (too large for base64 storage)
      await ChatService.sendMessage(
        senderId: _currentUserId!,
        receiverId: widget.specialistId,
        message: message,
        senderName: _currentUserName ?? 'User',
        // senderImage: not stored in Firebase
        receiverName: widget.specialistName,
        // receiverImage: not stored in Firebase
      );

      // Clear input after successful send
      _messageController.clear();
      
      // Scroll to bottom after sending (with a small delay to ensure message is rendered)
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients) {
            try {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } catch (e) {
              // Ignore scroll errors
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String _formatMessageTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return DateFormat('h:mm a').format(date);
  }

  String _formatDateHeader(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    
    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year && 
               date.month == now.month && 
               date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> messageData,
    bool isCurrentUser,
  ) {
    final message = messageData['message'] as String? ?? '';
    final timestamp = messageData['timestamp'] as Timestamp?;
    final isRead = messageData['read'] as bool? ?? false;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.accentTeal : AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isCurrentUser 
                    ? AppColors.white 
                    : AppColors.textBlack, // Brighter text color
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatMessageTime(timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isCurrentUser
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.textSecondary,
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead ? Icons.done_all : Icons.done,
                    size: 12,
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image
                      FutureBuilder<String?>(
                        future: widget.specialistImagePath != null
                            ? Future.value(widget.specialistImagePath)
                            : ImageCacheService.getImagePath(widget.specialistId),
                        builder: (context, imageSnapshot) {
                          final imagePath = imageSnapshot.data;
                          
                          return Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                ),
                                child: imagePath != null
                                    ? ClipOval(
                                        child: Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 32,
                                              color: AppColors.textSecondary,
                                            );
                                          },
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.textSecondary,
                                      ),
                              ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
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
                                size: 8,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.specialistName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      if (widget.specialization != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.specialization!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: AppColors.white),
                  onPressed: () {
                    // TODO: Show options menu
                  },
                ),
              ],
            ),
          ),
          // Messages List - Wrapped in RepaintBoundary to prevent rebuilds when keyboard appears/disappears
          Expanded(
            child: (_currentUserId == null || _messagesStream == null)
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
              stream: _messagesStream, // <-- use stored stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(
                        color: AppColors.errorRed,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                          'No messages yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs.reversed.toList();
                String? lastDate;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageDoc = messages[index];
                    final messageData =
                    messageDoc.data() as Map<String, dynamic>?;

                    if (messageData == null) return const SizedBox.shrink();

                    final timestamp = messageData['timestamp'] as Timestamp?;
                    final senderId = messageData['senderId'] as String?;
                    final isCurrentUser = senderId == _currentUserId;

                    String? dateHeader;
                    if (timestamp != null) {
                      final dateStr = _formatDateHeader(timestamp);
                      if (dateStr != lastDate) {
                        lastDate = dateStr;
                        dateHeader = dateStr;
                      }
                    }

                    return Column(
                      children: [
                        if (dateHeader != null) _buildDateHeader(dateHeader),
                        _buildMessageBubble(messageData, isCurrentUser),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorShadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning label
                  if (_showRestrictionWarning)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: AppColors.errorRed.withOpacity(0.1),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: AppColors.errorRed,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Numbers, links, and special characters (/, \\) are not allowed',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.errorRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message..',
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 5, // Limit to 5 lines, then scroll
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            inputFormatters: [
                              // Custom formatter that blocks restricted content
                              _RestrictedContentInputFormatter(
                                onRestrictedContent: (type) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        _showRestrictionWarning = true;
                                      });
                                      // Hide warning after 3 seconds
                                      Future.delayed(const Duration(seconds: 3), () {
                                        if (mounted) {
                                          setState(() {
                                            _showRestrictionWarning = false;
                                          });
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.accentTeal,
                          shape: BoxShape.circle,
                        ),
                        child: _isSending
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                                onPressed: _sendMessage,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

