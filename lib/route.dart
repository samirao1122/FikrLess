import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

// Splash & Before Login
import 'screens/splash_screen.dart';
import 'screens/before_login_signup/get_started_screen.dart';
import 'screens/before_login_signup/choose_yourself.dart';

// Auth
import 'screens/auth/login/login_screen.dart';
import 'screens/auth/login/login_with_email.dart';
import 'screens/auth/signup/signup_with_email.dart';
import 'screens/auth/signup/signup_with_phone.dart';
import 'screens/auth/otp/otp_signup.dart';
import 'screens/auth/otp/otp_reset_pasword.dart';
import 'screens/auth/otp/sucessfully_verified.dart';
import 'screens/auth/forget_pasword/forget_password.dart';
import 'screens/auth/forget_pasword/pasword_reset_screen.dart';
import 'screens/auth/forget_pasword/reset_sucessfully.dart';

// User Flow
import 'screens/userflow/home_screen.dart';
import 'screens/userflow/Demographies/basic_info_screen.dart';
import 'screens/userflow/Demographies/Consent&Safety.dart';
import 'screens/userflow/Demographies/current_mental_health_status.dart';
import 'screens/userflow/Demographies/lifeStyle&Support.dart';
import 'screens/userflow/Demographies/mental_health_goals.dart';
import 'screens/userflow/Demographies/preference.dart';

// Specialist Flow
import 'screens/specialistflow/Demographies/basic_information.dart';
import 'screens/specialistflow/Demographies/education_certification.dart';

/// ✅ Centralized route generator with locale handling
Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments as Map?;
  final locale = args?['locale'] as Locale? ?? const Locale('en');

  switch (settings.name) {
    // Splash & Before Login
    case '/':
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case '/getStarted':
      return MaterialPageRoute(builder: (_) => BeforeLogin(locale: locale));
    case '/chooseYourself':
      return MaterialPageRoute(
        builder: (_) => ChooseWhoAreYouScreen(locale: locale),
      );

    // Auth Screens
    case '/login':
      return MaterialPageRoute(builder: (_) => LoginScreen(locale: locale));
    case '/loginEmail':
      return MaterialPageRoute(
        builder: (_) => LoginScreenwithEmail(locale: locale),
      );
    case '/signupEmail':
      return MaterialPageRoute(
        builder: (_) => UserSignUpScreenEmail(
          role: args?['role'] ?? 'user',
          locale: locale,
        ),
      );
    case '/signupPhone':
      return MaterialPageRoute(
        builder: (_) =>
            userSignUpScreen(role: args?['role'] ?? 'user', locale: locale),
      );
    case '/otpSignup':
      return MaterialPageRoute(
        builder: (_) => UserOtpVerificationScreen(
          email: args?['email'] ?? '',
          phoneNumber: args?['phone'] ?? '',
          role: args?['role'] ?? 'user',
          locale: locale,
        ),
      );
    case '/otpResetPassword':
      return MaterialPageRoute(
        builder: (_) =>
            OtpForPaswordReset(email: args?['email'] ?? '', locale: locale),
      );
    case '/successfullyVerified':
      return MaterialPageRoute(
        builder: (_) => UserVerifiedScreen(
          contactValue: args?['email'] ?? '',
          isPhone: args?['isPhone'] ?? false,
          userId: args?['userId'] ?? '',
          role: args?['role'] ?? 'user',
          locale: locale,
        ),
      );
    case '/forgetPassword':
      return MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(locale: locale),
      );
    case '/passwordReset':
      return MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(
          contactValue: args?['email'] ?? '',
          isPhone: args?['isPhone'] ?? false,
          userId: args?['userId'] ?? '',
          token: args?['token'] ?? '',
          locale: locale,
        ),
      );
    case '/resetSuccess':
      return MaterialPageRoute(
        builder: (_) => ResetSuccessfully(locale: locale),
      );

    // User Flow
    case '/userDashboard':
      return MaterialPageRoute(builder: (_) => HomeScreen(locale: locale));
    case '/basicInfoUser':
      return MaterialPageRoute(
        builder: (_) => BasicDemographicsScreen(
          surveyData: args?['surveyData'],
          locale: locale,
        ),
      );
    case '/mentalHealthGoals':
      return MaterialPageRoute(
        builder: (_) => MentalHealthGoalsScreen(
          surveyData: args?['surveyData'],
          locale: locale,
        ),
      );
    case '/mentalHealthStatus':
      return MaterialPageRoute(
        builder: (_) => CurrentMentalHealthStatusScreen(
          surveyData: args?['surveyData'],
          locale: locale,
        ),
      );
    case '/lifeStyleSupport':
      return MaterialPageRoute(
        builder: (_) => LifestyleSupportScreen(
          surveyData: args?['surveyData'],
          locale: locale,
        ),
      );
    case '/preference':
      return MaterialPageRoute(
        builder: (_) =>
            PreferencesScreen(surveyData: args?['surveyData'], locale: locale),
      );
    case '/consentSafety':
      return MaterialPageRoute(
        builder: (_) => ConsentSafetyScreen(
          surveyData: args?['surveyData'],
          locale: locale,
        ),
      );

    // Specialist Flow
    case '/basicInformation':
      return MaterialPageRoute(
        builder: (_) => BasicInformationScreen(locale: locale),
      );
    case '/educationCertification':
      return MaterialPageRoute(
        builder: (_) => EducationCertificationsScreen(locale: locale),
      );

    // Default route
    default:
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: Center(
            child: Text(
              AppLocalizations.of(ctx)?.routeNotFound ?? 'Route not found',
            ),
          ),
        ),
      );
  }
}
