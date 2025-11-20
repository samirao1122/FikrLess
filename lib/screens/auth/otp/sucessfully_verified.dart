import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/auth_cache_service.dart';

import "../../userflow/Demographies/basic_info_screen.dart";
import "../../userflow/Demographies/user_survey_data.dart" show UserSurveyData;
import '../../specialistflow/Demographies/basic_information.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Localization

class UserVerifiedScreen extends StatelessWidget {
  final String contactValue;
  final bool isPhone;
  final String userId;
  final String role;
  final Locale locale; // ✅ added locale

  const UserVerifiedScreen({
    super.key,
    required this.contactValue,
    required this.isPhone,
    required this.userId,
    required this.role, // ✅ role
    required this.locale, // ✅ locale
  });

  // 🧩 Mask sensitive info
  String _maskContact(String contact) {
    if (isPhone) {
      if (contact.length > 6) {
        return contact.replaceRange(
          contact.length - 8,
          contact.length - 4,
          "****",
        );
      } else {
        return contact;
      }
    } else {
      final parts = contact.split('@');
      if (parts.length == 2 && parts[0].length > 3) {
        final prefix = parts[0].substring(0, 3);
        return '$prefix***@${parts[1]}';
      } else {
        return contact;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedContact = _maskContact(contactValue);

    return Localizations.override(
      context: context,
      locale: locale, // ✅ Apply selected locale
      child: Builder(
        builder: (context) {
          final local = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr, // ✅ RTL handling
            child: Scaffold(
              backgroundColor: AppColors.backgroundWhite,
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ✅ Success Tick Image
                        Image.asset(
                          'assets/images/otp_screen/tick.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        // ✅ Verified title
                        Text(
                          local.userVerifiedTitle,
                          style: TextStyle(
                            color: AppColors.tickGreen,
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // ✅ Masked contact info message
                        Text(
                          isPhone
                              ? local.userVerifiedPhoneMessage(maskedContact)
                              : local.userVerifiedEmailMessage(maskedContact),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textBlack54,
                            fontSize: 17,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // ✅ Setup Profile button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (role.toLowerCase() == "user") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BasicDemographicsScreen(
                                      locale: locale,
                                      surveyData: UserSurveyData(
                                        userId: userId,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (role.toLowerCase() == "specialist") {
                                // Get token from cache
                                final token = await AuthCacheService.getAuthToken();
                                if (token != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BasicInformationScreen(
                                        locale: locale,
                                        token: token,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(local.networkError),
                                      backgroundColor: AppColors.errorRed,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              local.setUpProfile, // ✅ localized
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 17,
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
            ),
          );
        },
      ),
    );
  }
}
