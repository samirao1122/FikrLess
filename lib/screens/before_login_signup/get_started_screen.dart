// 📦 Import Flutter Package
import 'package:flutter/material.dart';
import 'choose_yourself.dart'; // ✅ Import the ChooseYourself screen
import "../auth/login/login_screen.dart"; // ✅ Import the Login screen
import 'package:fikr_less/theme/app_colors.dart';
import 'package:fikr_less/l10n/app_localizations.dart';

// 🌿 Welcome Screen (Before Login)
class BeforeLogin extends StatefulWidget {
  const BeforeLogin({super.key, required Locale locale});

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
      context: context,
      locale: _currentLocale,
      child: Builder(
        builder: (context) {
          final local = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: true, // handle keyboard
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05), // responsive top spacing
                      // 🌱 Top Logo Image
                      Center(
                        child: SizedBox(
                          // ⭐ FIXED (replaced Flexible)
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            'assets/images/before_login/get_started_screen.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // 🧠 Main Heading
                      Text(
                        local.loginTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 38 * textScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.01),

                      // 💙 Highlighted Subheading
                      Text(
                        local.loginSubtitle,
                        style: TextStyle(
                          fontSize: 30 * textScale,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentTeal,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // 📝 Description
                      Text(
                        local.loginDescription,
                        style: TextStyle(
                          fontSize: 18 * textScale,
                          color: AppColors.textHint,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // 🌐 Language Toggle
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _toggleLanguage,
                          child: Text(
                            _currentLocale.languageCode == 'en'
                                ? 'اردو'
                                : 'English',
                            style: TextStyle(
                              fontSize: 14 * textScale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // 🚀 Get Started Button
                      SizedBox(
                        width: double.infinity,
                        height: (height * 0.06).clamp(50, 60),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseWhoAreYouScreen(
                                  locale: _currentLocale,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: FittedBox(
                            child: Text(
                              local.getStarted,
                              style: TextStyle(
                                fontSize: 16 * textScale,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      // 🔐 Log in Button
                      SizedBox(
                        width: double.infinity,
                        height: (height * 0.06).clamp(50, 60),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(locale: _currentLocale),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.accentTeal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),

                          child: FittedBox(
                            child: Text(
                              local.login,
                              style: TextStyle(
                                fontSize: 16 * textScale,
                                color: AppColors.accentTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
