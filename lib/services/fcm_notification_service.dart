import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// Service for handling Firebase Cloud Messaging notifications
class FCMNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize notification service
  static Future<void> initialize() async {
    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (if needed)
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications like chat messages.',
      importance: Importance.high,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Handle foreground messages (when app is open)
    // Based on Firebase FCM Flutter codelab best practices
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
    
    // Check if app was opened from a notification (handled in main.dart)
    // This is for terminated state, which is handled separately
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to chat screen here if needed
    print('Notification tapped: ${response.payload}');
  }

  /// Handle foreground messages (when app is open)
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');

    // Show local notification
    await _showNotification(
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? message.data['message'] ?? '',
      payload: message.data.toString(),
    );
  }

  /// Handle background message tap (when app is in background, not terminated)
  /// Based on Firebase FCM Flutter codelab best practices
  static void _handleBackgroundMessageTap(RemoteMessage message) {
    print('📱 Notification opened app from background: ${message.messageId}');
    print('   Title: ${message.notification?.title}');
    print('   Body: ${message.notification?.body}');
    print('   Data: ${message.data}');
    
    // Navigate to chat screen if it's a chat message
    if (message.data['type'] == 'chat_message') {
      final chatRoomId = message.data['chatRoomId'] as String?;
      final senderId = message.data['senderId'] as String?;
      print('💬 Opening chat room: $chatRoomId with sender: $senderId');
      // You can use a global navigator key here to navigate
      // Example: MyAppState.navigatorKey.currentState?.pushNamed('/chat', arguments: {...});
    }
  }

  /// Show local notification
  static Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show notification for chat message
  static Future<void> showChatNotification({
    required String senderName,
    required String message,
    String? chatRoomId,
  }) async {
    await _showNotification(
      title: senderName,
      body: message,
      payload: chatRoomId,
    );
  }
}

