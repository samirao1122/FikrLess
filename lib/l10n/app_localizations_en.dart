// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fikr Less';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get otp_sent => 'OTP sent successfully!';

  @override
  String get routeNotFound => 'Route not found';

  //  Added for BeforeLogin screen
  @override
  String get getStarted => 'Get Started';

  @override
  String get loginTitle => 'Your Safe Space for';

  @override
  String get loginSubtitle => 'Mental Wellness';

  @override
  String get loginDescription =>
      'FikrLess helps you track your mood, connect with support, and practice self-care in a stigma-free environment.';
}
