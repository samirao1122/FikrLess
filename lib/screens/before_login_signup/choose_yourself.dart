import 'package:flutter/material.dart';
import '../auth/signup/signup_with_phone.dart' show userSignUpScreen;
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart'; // Import localization

class ChooseWhoAreYouScreen extends StatelessWidget {
  final Locale locale;
  const ChooseWhoAreYouScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive text scaling
    final textScale = (screenWidth / 390).clamp(0.85, 1.15);
    // Get localized strings
    return Localizations.override(
      context: context,
      locale: locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          return Directionality(
            textDirection: locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxHeight = constraints.maxHeight;

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              // Top Image
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.85, // ⭐ Same as previous screen
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.40, // ⭐ Same as previous screen
                                    child: Image.asset(
                                      'assets/images/before_login/get_started_screen.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              // Bottom Section
                              Flexible(
                                flex: 5,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.colorShadow,
                                        blurRadius: 8,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Handle bar
                                      Center(
                                        child: Container(
                                          width: screenWidth * 0.4,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: AppColors.colorHandleBar,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Title
                                      Text(
                                        loc.chooseTitle,
                                        style: TextStyle(
                                          fontSize: 39 * textScale,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.colorBlack,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),

                                      // Subtitle
                                      Text(
                                        loc.chooseSubtitle,
                                        style: TextStyle(
                                          fontSize: 20 * textScale,
                                          color: AppColors.textHint,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 30),

                                      // Specialist Button
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  userSignUpScreen(
                                                    role: 'specialist',
                                                    locale:
                                                        locale, // ✅ Pass locale
                                                  ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.accentTeal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        child: Text(
                                          loc.signupSpecialist,
                                          style: TextStyle(
                                            fontSize: 19 * textScale,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),

                                      // User Button
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  userSignUpScreen(
                                                    role: 'user',
                                                    locale:
                                                        locale, // ✅ Pass locale
                                                  ),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: AppColors.accentTeal,
                                            width: 1.5,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        child: Text(
                                          loc.signupUser,
                                          style: TextStyle(
                                            fontSize: 19 * textScale,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.accentTeal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ); // ✅ HIGHLIGHTED
        },
      ),
    );
  }
}
