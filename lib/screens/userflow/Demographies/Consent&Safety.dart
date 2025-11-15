import 'dart:convert';
import 'package:fikr_less/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../auth/login/login_screen.dart';
import 'user_survey_data.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class ConsentSafetyScreen extends StatefulWidget {
  final UserSurveyData surveyData;
  final Locale locale; // ✅ store locale

  const ConsentSafetyScreen({
    super.key,
    required this.surveyData,
    required this.locale,
  });

  @override
  State<ConsentSafetyScreen> createState() => _ConsentSafetyScreenState();
}

class _ConsentSafetyScreenState extends State<ConsentSafetyScreen> {
  bool agree = false;

  final int totalSteps = 6;
  final int currentStep = 6;

  Future<void> _submitData() async {
    widget.surveyData.understandsEmergencyDisclaimer = agree;

    try {
      final url = Uri.parse(
        '$baseUrlSignUP/demographics',
      );

      final Map<String, dynamic> payload = widget.surveyData.toJson();
      if (widget.surveyData.userId != null) {
        payload["user_id"] = widget.surveyData.userId;
      } else {
        debugPrint("⚠️ Warning: userId is null in surveyData!");
      }

      debugPrint("📦 Sending payload: ${jsonEncode(payload)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.surveySubmitted),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(locale: widget.locale), // ✅ pass locale
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.surveySubmitFailed} (${response.statusCode}): ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.surveySubmitError}: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale, // ✅ override locale
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr, // ✅ dynamic LTR/RTL
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? CupertinoIcons.back
                                  : Icons.arrow_back_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              loc.consentSafetyTitle,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Card
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.colorShadow,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 145,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: AppColors.textBlack87,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Consent text
                              Text(
                                loc.consentMessage,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack87,
                                ),
                              ),
                              const SizedBox(height: 22),

                              CheckboxListTile(
                                value: agree,
                                onChanged: (val) =>
                                    setState(() => agree = val ?? false),
                                activeColor: AppColors.primary,
                                title: Text(
                                  loc.agreeCheckbox,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: AppColors.textBlack87,
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              const SizedBox(height: 35),

                              Text(
                                loc.safetyWarning,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: AppColors.textBlack87,
                                  height: 1.5,
                                ),
                              ),
                              const Spacer(),

                              // Submit button
                              Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: agree ? _submitData : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      disabledBackgroundColor:
                                          AppColors.progressGrey,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      loc.submitButton,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Progress bar
                              _buildSegmentedProgressBar(),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  loc.pageProgress(currentStep, totalSteps),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    color: AppColors.textBlack54,
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildSegmentedProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps, (index) {
        final isFilled = index < currentStep;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: isFilled ? AppColors.primary : AppColors.progressGrey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
