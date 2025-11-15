import 'package:flutter/material.dart';

/// Single source of truth for colors.
class AppColors {
  AppColors._(); // Prevent instantiation

  // 🌊 Primary brand color
  static const Color mainColor = Color(0xFF0097B2);

  // 🌿 Aqua variations
  static const Color softAqua = Color(0xFFB8ECEB);
  static const Color coolTeal = Color(0xFF74D3D0);
  static const Color darkTeal = Color(0xFF7FBAC0);
  static const Color frostedMint = Color(0xFFE9FDFC);
  static const Color dustyAqua = Color(0xFFA8DEE0);
  static const Color softAquaMint = Color(0xFFA7E9E3);
  static const Color paleTurquoise = Color(0xFFBCECE0);
  static const Color icyWhite = Color(0xFFE7F9F8);
  static const Color softSeafoamGreen = Color(0xFFD3F5EC);

  // 🖋 Text & surfaces
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color background = Color(0xFFF8FAFA);
  static const Color white = Colors.white;
  static const Color colorBlack = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color textHint = Colors.black54;
  static const Color textTertiary = Colors.black38;
  static const Color borderLight = Colors.black26;

  // 💎 Accents
  static const Color accentTeal = Color(0xFF0196B1);
  static const Color errorRed = Colors.redAccent;
  static const Color colorHandleBar = Color.fromARGB(255, 27, 27, 27);
  static const Color colorShadow = Colors.black12;

  static const Color textBlack87 = Colors.black87;
  static const Color textBlack54 = Colors.black54;
  static const Color textBlack38 = Colors.black38;
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);
  static const Color primary = Color(0xFF00A8A8);
  static const Color hintVeryLight = Color.fromARGB(75, 0, 0, 0);

  static const Color snackbarDark = Color(0xFF212121);
  static const Color snackbarError = Color(0xFF3E2723);
  static const Color borderGrey = Colors.grey;

  // 💚 Newly added colors for ResetPasswordScreen
  static const Color errorPureRed = Colors.red; // 💚 For validation text
  static const Color primaryDarkBlue = Color(0xFF01394F); // 💚 Title text
  static const Color textGrey700 = Color(0xFF616161); // 💚 Label text
  static const Color backgroundGrey100 = Color(
    0xFFF5F5F5,
  ); // 💚 Input background
  static const Color borderGrey300 = Color(0xFFE0E0E0); // 💚 Input border
  static const Color successGreen = Colors.green; // 💚 Success snackbar

  // 🟩 Additional colors for EducationCertificationsScreen & shared UI
  static const Color gradientTop = Color.fromARGB(
    108,
    78,
    194,
    194,
  ); // Gradient start
  static const Color gradientBottom = Color(0xFFF8F8F8); // Gradient end

  // Glass card background variations
  static const Color cardWhite25 = Color.fromRGBO(255, 255, 255, 0.25);
  static const Color cardWhite50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color cardWhite70 = Color.fromRGBO(255, 255, 255, 0.7);
  static const Color cardWhite85 = Color.fromRGBO(255, 255, 255, 0.85);

  static const Color cardBorderWhite40 = Color.fromRGBO(
    255,
    255,
    255,
    0.4,
  ); // Glass card border
  static const Color shadowLight = Color.fromRGBO(
    0,
    0,
    0,
    0.05,
  ); // Subtle box shadow
  static const Color chipBlue = Color(0xFFE0F7FA); // Chip background
  static const Color chipAddGrey = Color(0xFFE0E0E0); // "+ Add" chip
  static const Color progressBackground = Color(
    0xFFE0E0E0,
  ); // Progress bar background
  static const Color progressPrimary = Color(0xFF00A8A8); // Progress bar fill
  static const Color dialogBackground = Color(
    0xFFFFFFFF,
  ); // Alert dialog background

  static const Color tickGreen = Color(
    0xFF00C853,
  ); // "Successfully Verified" title
  static const Color prefillGray = Color.fromARGB(
    40,
    126,
    123,
    123,
  ); // Pinput prefilled widget
  static const Color infoBoxBackground = Color(
    0xFFE8F6FA,
  ); // Light info/disclaimer box
  static const Color progressGrey = Color(
    0xFFBDBDBD,
  ); // Unfilled segments for progress bar
  static const Color timerText = Color(
    0xFF00A8A8,
  ); // Timer countdown color in OTP screen
  static const Color resendText = Color(0xFF00A8A8); // Resend OTP link
  static const Color otpBorder = Color(0xFF000000); // Pinput default border
  static const Color otpFocusedBorder = Color(
    0xFF00A8A8,
  ); // Pinput focused border
  static const Color otpTextColor = Color(0xFF000000); // Pinput text color
  static const Color scaffoldBackground = Color(0xFFF7F9FB);
  static const Color cardShadow = Color.fromRGBO(
    128,
    128,
    128,
    0.18,
  ); // Approximate grey with opacity
  static const Color dividerBar = Color.fromRGBO(0, 0, 0, 0.8);
  static const Color splashGradientMiddle = Color(0xFF9FEDE6);
  static const Color splashGradientBottom = Color(0xFFB9F3EC);
  static Color blackOpacity80 = Colors.black.withOpacity(0.8);
}
