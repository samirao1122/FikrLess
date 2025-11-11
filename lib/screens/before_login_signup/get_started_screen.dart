// 📦 Import Flutter Package
import 'package:flutter/material.dart';
import 'choose_yourself.dart'; // ✅ Import the ChooseYourself screen
import "../auth/login/login_screen.dart"; // ✅ get started Import the Login screen
import 'package:fikr_less/theme/app_colors.dart';
import 'package:fikr_less/l10n/app_localizations.dart';

// 🌿 Welcome Screen (Before Login)
class BeforeLogin extends StatefulWidget {
  const BeforeLogin({super.key});

  @override
  State<BeforeLogin> createState() => _BeforeLoginState();
}

class _BeforeLoginState extends State<BeforeLogin> {
  Locale _currentLocale = const Locale('en'); // ✅ Default locale

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ur')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    // 📱 Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // 🔤 Scale factors for text and spacing
    final textScale = (width / 390).clamp(0.85, 1.2);
    final imageHeight = height * 0.40;
    final imageWidth = width * 0.85;

    return Localizations.override(
      // ✅ Wrap Scaffold with Localizations.override for dynamic locale
      context: context,
      locale: _currentLocale,
      child: Builder(
        // ✅ Added Builder to get correct context
        builder: (context) {
          final local = AppLocalizations.of(
            context,
          )!; // ✅ Now uses overridden locale
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, // responsive horizontal padding
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.1), // responsive top spacing
                      // 🌱 Top Logo Image
                      Center(
                        child: Image.asset(
                          'assets/images/before_login/get_started_screen.png',
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // 🧠 Main Heading
                      Text(
                        local.loginTitle, //'Your Safe Space for',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 38 * textScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.01),

                      // 💙 Highlighted Subheading
                      Text(
                        local.loginSubtitle, //'Mental Wellness',

                        style: TextStyle(
                          fontSize: 30 * textScale,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentTeal,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // 📝 Description
                      Text(
                        local
                            .loginDescription, //'FikrLess helps you track your mood, connect with support, and practice self-care in a stigma-free environment.',
                        style: TextStyle(
                          fontSize: 18 * textScale,
                          color: AppColors.textHint,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _toggleLanguage, // ✅ Toggle language
                          child: Text(
                            _currentLocale.languageCode == 'en'
                                ? 'اردو' // Show Urdu text when English is active
                                : 'English', // Show English text when Urdu is active
                            style: TextStyle(
                              fontSize: 14 * textScale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ),
                      ),

                      // 🚀 Get Started Button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            // ✅ Navigate to ChooseYourself screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseWhoAreYouScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Text(
                            local.getStarted, //'Get Started',
                            style: TextStyle(
                              fontSize: 16 * textScale,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      // 🔐 Log in Button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.05,
                        child: OutlinedButton(
                          onPressed: () {
                            // ✅ Navigate to Login Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.accentTeal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            local.login, //'Log in',
                            style: TextStyle(
                              fontSize: 16 * textScale,
                              color: AppColors.accentTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
