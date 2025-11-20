import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for sending FCM push notifications
/// 
/// ⚠️ IMPORTANT: FCM Legacy API is deprecated!
/// 
/// This client-side implementation is NOT RECOMMENDED for production.
/// The FCM HTTP v1 API requires service account credentials and OAuth2,
/// which should NEVER be stored in client apps.
/// 
/// ✅ RECOMMENDED SOLUTIONS:
/// 1. Use Firebase Cloud Functions (automatic, secure, serverless)
/// 2. Add endpoint to your backend API (https://fikrless.com/api/v1)
/// 
/// See FCM_NOTIFICATION_SETUP.md for complete setup guide.
/// 
/// This class is kept for backward compatibility but will not work
/// with the new FCM HTTP v1 API from client-side.
class FCMSenderService {
  // ⚠️ DEPRECATED: Legacy API no longer available
  // This will not work with FCM HTTP v1 API
  // Use Cloud Functions or backend API instead
  static const String _fcmServerKey = 'DEPRECATED_LEGACY_API';
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  /// Send a push notification to a specific FCM token
  /// 
  /// ⚠️ DEPRECATED: This method uses the Legacy FCM API which is no longer available.
  /// 
  /// Use one of these alternatives instead:
  /// 1. Firebase Cloud Functions (recommended - see FCM_NOTIFICATION_SETUP.md)
  /// 2. Backend API endpoint
  /// 
  /// Returns false (will not work with v1 API)
  static Future<bool> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      print('⚠️ WARNING: FCM Legacy API is deprecated and no longer available.');
      print('   This method will not work. Please use Cloud Functions or backend API.');
      print('   See FCM_NOTIFICATION_SETUP.md for setup instructions.');
      return false;
      
      // Legacy code below (will not execute)
      if (_fcmServerKey == 'DEPRECATED_LEGACY_API' || _fcmServerKey.isEmpty) {
        print('⚠️ FCM Legacy API is deprecated. Use Cloud Functions instead.');
        return false;
      }

      // Prepare notification payload
      final payload = {
        'to': fcmToken,
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
        },
        'data': data ?? {},
        'priority': 'high',
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': 'high_importance_channel',
            'sound': 'default',
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'sound': 'default',
              'badge': 1,
            },
          },
        },
      };

      // Send HTTP POST request to FCM
      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == 1 || responseData['failure'] == 0) {
          print('✅ FCM notification sent successfully');
          return true;
        } else {
          print('❌ FCM notification failed: ${responseData['results']}');
          return false;
        }
      } else {
        print('❌ FCM HTTP error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending FCM notification: $e');
      return false;
    }
  }

  /// Send a chat message notification
  static Future<bool> sendChatNotification({
    required String fcmToken,
    required String senderName,
    required String message,
    String? chatRoomId,
    String? senderId,
  }) async {
    return await sendNotification(
      fcmToken: fcmToken,
      title: senderName,
      body: message,
      data: {
        'type': 'chat_message',
        'chatRoomId': chatRoomId ?? '',
        'senderId': senderId ?? '',
        'message': message,
      },
    );
  }
}

