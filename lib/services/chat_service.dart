import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'fcm_sender_service.dart';

/// Service for managing chat functionality with Firebase
class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Generate a unique chat room ID from two user IDs
  /// Ensures the same room ID regardless of order
  static String _getChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  /// Send a message to a chat room
  /// Note: Images are not stored in Firebase (too large for base64)
  static Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required String senderName,
    String? senderImage, // Not stored in Firebase, kept for API compatibility
    String? receiverName,
    String? receiverImage, // Not stored in Firebase, kept for API compatibility
  }) async {
    try {
      final chatRoomId = _getChatRoomId(senderId, receiverId);
      final timestamp = FieldValue.serverTimestamp();

      // Create message document
      final messageData = {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp,
        'read': false,
      };

      // Add message to messages subcollection
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      // Update chat room metadata
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'lastMessageTime': timestamp,
        'lastMessageSenderId': senderId,
        'updatedAt': timestamp,
        // Store user info for easy access (without images - too large for Firestore)
        'users': {
          senderId: {
            'name': senderName,
            // Image not stored - fetch from API/cache when needed
          },
          receiverId: {
            'name': receiverName ?? 'Specialist',
            // Image not stored - fetch from API/cache when needed
          },
        },
      }, SetOptions(merge: true));
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      // Send push notification to receiver (non-blocking - won't affect chat if it fails)
      _sendNotification(
        receiverId: receiverId,
        senderName: senderName,
        message: message,
        chatRoomId: chatRoomId,
        senderId: senderId,
      ).catchError((error) {
        // Silently handle notification errors - chat still works
        print('Notification error (chat still works): $error');
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  /// Get messages stream for a chat room
  static Stream<QuerySnapshot> getMessagesStream({
    required String userId1,
    required String userId2,
  }) {
    final chatRoomId = _getChatRoomId(userId1, userId2);
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Get chat rooms list for a user
  /// Uses orderBy if index is available, otherwise falls back to unsorted query
  static Stream<QuerySnapshot> getChatRoomsStream(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
  
  /// Get chat rooms list without ordering (fallback when index is not available)
  static Stream<QuerySnapshot> getChatRoomsStreamFallback(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .snapshots();
  }

  /// Mark messages as read
  static Future<void> markMessagesAsRead({
    required String userId1,
    required String userId2,
    required String currentUserId,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId1, userId2);
      final messagesSnapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  /// Get unread message count for a chat room
  static Future<int> getUnreadCount({
    required String userId1,
    required String userId2,
    required String currentUserId,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId1, userId2);
      final snapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Get total unread count for all chat rooms
  static Stream<int> getTotalUnreadCountStream(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      int total = 0;
      for (var doc in snapshot.docs) {
        final chatRoomId = doc.id;
        final participants = doc.data()['participants'] as List?;
        if (participants != null && participants.length == 2) {
          final otherUserId = participants.firstWhere((id) => id != userId);
          final count = await getUnreadCount(
            userId1: userId,
            userId2: otherUserId,
            currentUserId: userId,
          );
          total += count;
        }
      }
      return total;
    });
  }

  /// Send push notification
  /// 
  /// ⚠️ IMPORTANT: Client-side FCM sending is deprecated!
  /// 
  /// The FCM Legacy API is no longer available. This method will not work.
  /// 
  /// ✅ RECOMMENDED: Use Firebase Cloud Functions (automatic trigger)
  /// See FCM_NOTIFICATION_SETUP.md for setup instructions.
  /// 
  /// Alternative: Add endpoint to your backend API at https://fikrless.com/api/v1
  static Future<void> _sendNotification({
    required String receiverId,
    required String senderName,
    required String message,
    String? chatRoomId,
    String? senderId,
  }) async {
    try {
      // Get receiver's FCM token from Firestore
      final receiverDoc = await _firestore
          .collection('users')
          .doc(receiverId)
          .get();

      final fcmToken = receiverDoc.data()?['fcmToken'] as String?;
      
      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ No FCM token found for user $receiverId');
        return;
      }

      // ⚠️ DEPRECATED: Client-side FCM sending no longer works
      // Use Cloud Functions instead (see FCM_NOTIFICATION_SETUP.md)
      // 
      // For now, this will fail silently. Set up Cloud Functions to enable notifications.
      print('⚠️ Client-side FCM sending is deprecated. Set up Cloud Functions for notifications.');
      print('   See FCM_NOTIFICATION_SETUP.md for instructions.');
      
      // Commented out - will not work with v1 API
      // final success = await FCMSenderService.sendChatNotification(
      //   fcmToken: fcmToken,
      //   senderName: senderName,
      //   message: message,
      //   chatRoomId: chatRoomId,
      //   senderId: senderId,
      // );
    } catch (e) {
      print('❌ Error sending notification: $e');
      // Don't throw - notification failure shouldn't break chat
    }
  }

  /// Save FCM token for a user
  static Future<void> saveFCMToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  /// Request notification permissions and get FCM token
  /// Based on Firebase FCM Flutter codelab best practices
  static Future<String?> initializeFCM(String userId) async {
    try {
      // Request permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        final token = await _messaging.getToken();
        if (token != null) {
          await saveFCMToken(userId, token);
          
          // Monitor token refresh (important for long-running apps)
          // When token refreshes, update it in Firestore
          _messaging.onTokenRefresh.listen((newToken) {
            print('🔄 FCM token refreshed for user $userId');
            saveFCMToken(userId, newToken).catchError((error) {
              print('Error saving refreshed token: $error');
            });
          });
          
          return token;
        }
      }
      return null;
    } catch (e) {
      print('Error initializing FCM: $e');
      return null;
    }
  }
}

