import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'route.dart'; // ✅ new import
import 'services/auth_cache_service.dart';
import 'services/audio_player_service.dart';
import 'services/audio_notification_service.dart';
import 'services/chat_service.dart';
import 'services/fcm_notification_service.dart';
import 'services/image_cache_service.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('📱 Handling background message: ${message.messageId}');
  print('   Title: ${message.notification?.title}');
  print('   Body: ${message.notification?.body}');
  print('   Data: ${message.data}');
  
  // Handle chat notifications
  if (message.data['type'] == 'chat_message') {
    print('💬 Chat message notification received');
    // The notification will be shown automatically by the system
    // You can add custom handling here if needed
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up FCM background handler (must be called before runApp)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize FCM notification service
  await FCMNotificationService.initialize();
  
  // Handle initial message when app is opened from terminated state
  // Based on Firebase FCM Flutter codelab best practices
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('📱 App opened from terminated state via notification');
    print('   Title: ${initialMessage.notification?.title}');
    print('   Body: ${initialMessage.notification?.body}');
    print('   Data: ${initialMessage.data}');
    // You can navigate to chat screen here if needed
    // Example: MyAppState.navigatorKey.currentState?.pushNamed('/chat', arguments: {...});
  }
  
  // Request FCM permissions and get token (for all users, not just logged-in)
  // This is done here to ensure permissions are requested early
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('🔔 FCM Permission status: ${settings.authorizationStatus}');
  }
  
  // Get registration token (useful for debugging)
  // Note: Token will be saved to Firestore in ChatService.initializeFCM() for logged-in users
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    final token = await messaging.getToken();
    if (kDebugMode && token != null) {
      print('📱 FCM Registration Token: $token');
    }
  }
  // Initialize image cache service
  await ImageCacheService.initialize();
  
  // Initialize audio player service
  AudioPlayerService().initialize();
  // Clear any stale notifications from previous app session
  await _clearStaleNotifications();
  
  // Initialize FCM for logged-in users (optional - chat works without it)
  final userId = await AuthCacheService.getUserId();
  if (userId != null) {
    ChatService.initializeFCM(userId).catchError((error) {
      print('FCM initialization failed (chat still works): $error');
    });
  }
  
  runApp(const MyApp());
}

Future<void> _clearStaleNotifications() async {
  try {
    // Directly cancel all notifications using the plugin
    // This works even if the service isn't initialized
    final notifications = FlutterLocalNotificationsPlugin();
    
    // Cancel the specific audio player notification
    await notifications.cancel(1001);
    
    // Also cancel all notifications to be safe
    await notifications.cancelAll();
    
    // Stop any audio that might be playing
    final audioService = AudioPlayerService();
    await audioService.stop();
  } catch (e) {
    print('Error clearing stale notifications: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale = const Locale('en');
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLanguage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.detached) {
      // When app is being terminated/closed, stop audio and hide notification
      _stopAudioAndClearNotification();
    }
  }

  Future<void> _stopAudioAndClearNotification() async {
    try {
      // Stop audio service
      final audioService = AudioPlayerService();
      await audioService.stop();
      
      // Cancel notification directly using plugin (works even if service not initialized)
      final notifications = FlutterLocalNotificationsPlugin();
      await notifications.cancel(1001);
      await notifications.cancelAll();
    } catch (e) {
      print('Error stopping audio and clearing notification: $e');
    }
  }

  Future<void> _loadLanguage() async {
    final savedLang = await AuthCacheService.getLanguage();
    if (mounted) {
      setState(() {
        _locale = Locale(savedLang);
      });
    }
  }

  static MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>();
  }
  
  void updateLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _locale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // ✅ Localization setup
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,

        title: 'Fikr Less',
        theme: ThemeData(primarySwatch: Colors.blue),

        // ✅ Routing moved out
        navigatorKey: MyAppState.navigatorKey,
        initialRoute: '/',
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

