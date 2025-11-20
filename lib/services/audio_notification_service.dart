import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'audio_player_service.dart';
import '../main.dart';
import '../screens/userflow/wellness/guided_meditations_screen.dart';
import '../services/auth_cache_service.dart';

/// Service for managing Android system notifications for audio playback
class AudioNotificationService {
  static final AudioNotificationService _instance = AudioNotificationService._internal();
  factory AudioNotificationService() => _instance;
  AudioNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _isNotificationVisible = false;
  StreamSubscription? _isPlayingSubscription;
  StreamSubscription? _positionSubscription;
  Timer? _updateTimer;

  static const String _channelId = 'audio_player_channel';
  static const String _channelName = 'Audio Player';
  static const String _channelDescription = 'Shows audio playback controls';
  static const int _notificationId = 1001;

  /// Initialize notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request notification permission for Android 13+
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (!status.isGranted) {
          print('Notification permission not granted');
          return false;
        }
      }

      // Initialize Android settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android 8.0+
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      _isInitialized = true;
      
      // Clear any existing notifications on startup
      await _notifications.cancel(_notificationId);
      await _notifications.cancelAll();
      _isNotificationVisible = false;
      
      _setupAudioServiceListeners();
      return true;
    } catch (e) {
      print('Error initializing notification service: $e');
      return false;
    }
  }

  void _setupAudioServiceListeners() {
    final audioService = AudioPlayerService();

    // Check if audio is already playing and show notification
    if (audioService.currentAudioPath != null) {
      _showNotification();
    }

    // Listen to playing state
    _isPlayingSubscription = audioService.isPlayingStream.listen((isPlaying) {
      if (audioService.currentAudioPath != null) {
        if (!_isNotificationVisible) {
          _showNotification();
        } else {
          // Always update notification when state changes
          _updateNotification();
        }
      } else if (!isPlaying && _isNotificationVisible) {
        // Hide notification if audio stopped
        _hideNotification();
      }
    });

    // Update notification position periodically
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isNotificationVisible && audioService.currentAudioPath != null) {
        _updateNotification();
      } else if (_isNotificationVisible && audioService.currentAudioPath == null) {
        _hideNotification();
      }
    });
  }

  void _onNotificationTapped(NotificationResponse response) async {
    // Handle notification tap - navigate to guided meditations screen
    print('Notification tapped: ${response.actionId}');
    
    final audioService = AudioPlayerService();
    
    // Handle action buttons
    if (response.actionId == 'play_pause') {
      await audioService.togglePlayPause();
      // Update notification to reflect new state
      await Future.delayed(const Duration(milliseconds: 100));
      _updateNotification();
    } else if (response.actionId == 'stop') {
      await audioService.stop();
      _hideNotification();
    } else {
      // Tap on notification body - navigate to guided meditations screen
      final navigatorKey = MyAppState.navigatorKey;
      if (navigatorKey.currentContext != null) {
        final savedLang = await AuthCacheService.getLanguage();
        final locale = Locale(savedLang);
        
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => GuidedMeditationsScreen(locale: locale),
          ),
        );
      }
    }
  }

  Future<void> _showNotification() async {
    if (!_isInitialized) return;

    final audioService = AudioPlayerService();
    final audioName = _getAudioName(audioService.currentAudioIndex);
    final isPlaying = audioService.isPlaying;
    final position = audioService.currentPosition;
    final duration = audioService.totalDuration;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      actions: [
        AndroidNotificationAction(
          'play_pause',
          isPlaying ? 'Pause' : 'Play',
          icon: DrawableResourceAndroidBitmap(
            isPlaying 
              ? '@android:drawable/ic_media_pause'
              : '@android:drawable/ic_media_play',
          ),
        ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          icon: DrawableResourceAndroidBitmap('@android:drawable/ic_menu_close_clear_cancel'),
        ),
      ],
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      _notificationId,
      audioName,
      _formatTime(position, duration),
      notificationDetails,
    );

    _isNotificationVisible = true;
  }

  Future<void> _updateNotification() async {
    if (!_isInitialized || !_isNotificationVisible) return;

    final audioService = AudioPlayerService();
    
    // Hide notification if audio stopped
    if (audioService.currentAudioPath == null) {
      await _hideNotification();
      return;
    }

    final audioName = _getAudioName(audioService.currentAudioIndex);
    final isPlaying = audioService.isPlaying;
    final position = audioService.currentPosition;
    final duration = audioService.totalDuration;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      actions: [
        AndroidNotificationAction(
          'play_pause',
          isPlaying ? 'Pause' : 'Play',
          icon: DrawableResourceAndroidBitmap(
            isPlaying 
              ? '@android:drawable/ic_media_pause'
              : '@android:drawable/ic_media_play',
          ),
        ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          icon: DrawableResourceAndroidBitmap('@android:drawable/ic_menu_close_clear_cancel'),
        ),
      ],
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      _notificationId,
      audioName,
      _formatTime(position, duration),
      notificationDetails,
    );
  }

  Future<void> _hideNotification() async {
    if (!_isInitialized) return;
    await _notifications.cancel(_notificationId);
    _isNotificationVisible = false;
  }

  /// Public method to hide notification (called when app closes)
  Future<void> hideNotification() async {
    await _hideNotification();
  }

  /// Force cancel all notifications (used when app is killed)
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      _isNotificationVisible = false;
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }

  String _getAudioName(int? index) {
    if (index != null) {
      return 'Meditation ${index + 1}';
    }
    return 'Audio';
  }

  String _formatTime(Duration position, Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final posMinutes = twoDigits(position.inMinutes.remainder(60));
    final posSeconds = twoDigits(position.inSeconds.remainder(60));
    final durMinutes = twoDigits(duration.inMinutes.remainder(60));
    final durSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$posMinutes:$posSeconds / $durMinutes:$durSeconds';
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    if (await Permission.notification.isGranted) {
      return true;
    }
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Dispose resources
  void dispose() {
    _isPlayingSubscription?.cancel();
    _updateTimer?.cancel();
    _hideNotification();
  }
}

