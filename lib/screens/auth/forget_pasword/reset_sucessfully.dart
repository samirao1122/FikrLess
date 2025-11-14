import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart'; // Import localization

class ResetSuccessfully extends StatelessWidget {
  final Locale locale; // ✅ HIGHLIGHT: accept locale

  const ResetSuccessfully({
    super.key,
    required this.locale,
  }); // ✅ HIGHLIGHT: pass locale

  @override
  Widget build(BuildContext context) {
    // ✅ HIGHLIGHT: Override localization using passed locale
    return Localizations.override(
      context: context,
      locale: locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!; // ✅ localized text

          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;

          double h(double value) => screenHeight * value;
          double w(double value) => screenWidth * value;
          double f(double value) => screenWidth * value / 375;

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w(0.085)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/otp_screen/tick.png',
                        width: w(0.24),
                        height: w(0.24),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: h(0.015)),
                      Text(
                        loc.userVerifiedTitle, // ✅ localized
                        style: TextStyle(
                          color: AppColors.successGreen,
                          fontSize: f(38),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: h(0.024)),
                      Text(
                        loc.passwordResetSuccessMessage, // ✅ localized
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: f(17),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: h(0.106)),
                      SizedBox(
                        width: double.infinity,
                        height: h(0.065),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(locale: locale),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            loc.login, // ✅ localized
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: f(19),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
