import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- add
import 'l10n/app_localizations.dart'; // <-- add

// Splash
import 'screens/splash_screen.dart';

// Before Login/Signup
import 'screens/before_login_signup/get_started_screen.dart';
import 'screens/before_login_signup/choose_yourself.dart';

// Auth - Login, Signup, OTP, Forget Password
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
import 'screens/userflow/user_dashboard.dart';
import 'screens/userflow/Demographies/basic_info_screen.dart';
import 'screens/userflow/Demographies/Consent&Safety.dart';
import 'screens/userflow/Demographies/current_mental_health_status.dart';
import 'screens/userflow/Demographies/lifeStyle&Support.dart';
import 'screens/userflow/Demographies/mental_health_goals.dart';
import 'screens/userflow/Demographies/preference.dart';

// Specialist Flow
import 'screens/specialistflow/Demographies/basic_information.dart';
import 'screens/specialistflow/Demographies/education_certification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ------ L10N (add these) ------
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // optional: force a language or implement a setting
      // locale: const Locale('en'),
      // --------------------------------
      title: AppLocalizations.of(context)?.appTitle,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash & Before Login
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/getStarted':
        return MaterialPageRoute(builder: (_) => const BeforeLogin());
      case '/chooseYourself':
        return MaterialPageRoute(builder: (_) => const ChooseWhoAreYouScreen());

      // Auth Screens
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/loginEmail':
        return MaterialPageRoute(builder: (_) => const LoginScreenwithEmail());
      case '/signupEmail':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => UserSignUpScreenEmail(role: args?['role'] ?? 'user'),
        );
      case '/signupPhone':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => userSignUpScreen(role: args?['role'] ?? 'user'),
        );
      case '/otpSignup':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => UserOtpVerificationScreen(
            email: args?['email'] ?? '',
            phoneNumber: args?['phone'] ?? '',
            role: args?['role'] ?? 'user',
          ),
        );
      case '/otpResetPassword':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => OtpForPaswordReset(email: args?['email'] ?? ''),
        );
      case '/successfullyVerified':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => userVerifiedScreen(
            contactValue: args?['email'] ?? '',
            isPhone: args?['isPhone'] ?? false,
            userId: args?['userId'] ?? '',
            role: args?['role'] ?? 'user',
          ),
        );
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/passwordReset':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            contactValue: args?['email'] ?? '',
            isPhone: args?['isPhone'] ?? false,
            userId: args?['userId'] ?? '',
            token: args?['token'] ?? '',
          ),
        );
      case '/resetSuccess':
        return MaterialPageRoute(builder: (_) => const reset_sucessfully());

      // User Flow
      case '/userDashboard':
        return MaterialPageRoute(builder: (_) => const UserScreen());
      case '/basicInfoUser':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) =>
              BasicDemographicsScreen(surveyData: args?['surveyData']),
        );
      case '/mentalHealthGoals':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) =>
              MentalHealthGoalsScreen(surveyData: args?['surveyData']),
        );
      case '/mentalHealthStatus':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) =>
              CurrentMentalHealthStatusScreen(surveyData: args?['surveyData']),
        );
      case '/lifeStyleSupport':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) =>
              LifestyleSupportScreen(surveyData: args?['surveyData']),
        );
      case '/preference':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => PreferencesScreen(surveyData: args?['surveyData']),
        );
      case '/consentSafety':
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => ConsentSafetyScreen(surveyData: args?['surveyData']),
        );

      // Specialist Flow
      case '/basicInformation':
        return MaterialPageRoute(
          builder: (_) => const BasicInformationScreen(),
        );
      case '/educationCertification':
        return MaterialPageRoute(
          builder: (_) => const EducationCertificationsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            body: Center(
              // localized “route not found” if you add a key in ARB
              child: Text(
                AppLocalizations.of(ctx)?.routeNotFound ?? 'Route not found',
              ),
            ),
          ),
        );
    }
  }
}
