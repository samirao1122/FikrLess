import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_survey_data.dart'; // ✅ Shared survey model
import 'preference.dart'; // ✅ Step 5 screen
import '../../../theme/app_colors.dart'; // ✅ Centralized colors
import '../../../l10n/app_localizations.dart'; // ✅ Localization

class LifestyleSupportScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ Receive previous data
  final Locale locale; // ✅ Added locale field

  const LifestyleSupportScreen({
    super.key,
    required this.surveyData,
    required this.locale,
  });

  @override
  State<LifestyleSupportScreen> createState() => _LifestyleSupportScreenState();
}

class _LifestyleSupportScreenState extends State<LifestyleSupportScreen> {
  String? exerciseFrequency;
  String? substanceUse;
  String? supportSystem;

  final int totalSteps = 6;
  final int currentStep = 4; // Step 4 of 6

  void _onNext() {
    // ✅ Save answers to shared UserSurveyData
    widget.surveyData.exerciseFrequency = exerciseFrequency;
    widget.surveyData.substanceUse = substanceUse;
    widget.surveyData.supportSystem = supportSystem;

    // ✅ Navigate to next screen with same surveyData and locale
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreferencesScreen(
          surveyData: widget.surveyData,
          locale: widget.locale,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 35, bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? CupertinoIcons.back
                                    : Icons.arrow_back_rounded,
                                color: AppColors.accentTeal,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                loc.lifestyleSupportTitle,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Card container
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress bar top divider
                            Center(
                              child: Container(
                                width: 120,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.dividerBar,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // Exercise Frequency question
                            Text(
                              loc.exerciseFrequencyQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRadioOption(
                              loc.exerciseOptionNever,
                              exerciseFrequency,
                              (val) => setState(() => exerciseFrequency = val),
                            ),
                            _buildRadioOption(
                              loc.exerciseOptionOccasionally,
                              exerciseFrequency,
                              (val) => setState(() => exerciseFrequency = val),
                            ),
                            _buildRadioOption(
                              loc.exerciseOptionWeekly,
                              exerciseFrequency,
                              (val) => setState(() => exerciseFrequency = val),
                            ),
                            _buildRadioOption(
                              loc.exerciseOptionDaily,
                              exerciseFrequency,
                              (val) => setState(() => exerciseFrequency = val),
                            ),
                            const SizedBox(height: 20),

                            // Substance Use question
                            Text(
                              loc.substanceUseQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRadioOption(
                              loc.substanceOptionNever,
                              substanceUse,
                              (val) => setState(() => substanceUse = val),
                            ),
                            _buildRadioOption(
                              loc.substanceOptionOccasionally,
                              substanceUse,
                              (val) => setState(() => substanceUse = val),
                            ),
                            _buildRadioOption(
                              loc.substanceOptionFrequently,
                              substanceUse,
                              (val) => setState(() => substanceUse = val),
                            ),
                            const SizedBox(height: 20),

                            // Support System question
                            Text(
                              loc.supportSystemQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRadioOption(
                              loc.supportOptionYes,
                              supportSystem,
                              (val) => setState(() => supportSystem = val),
                            ),
                            _buildRadioOption(
                              loc.supportOptionSomewhat,
                              supportSystem,
                              (val) => setState(() => supportSystem = val),
                            ),
                            _buildRadioOption(
                              loc.supportOptionNo,
                              supportSystem,
                              (val) => setState(() => supportSystem = val),
                            ),
                            const SizedBox(height: 28),

                            // Next button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentTeal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                label: Text(
                                  loc.lifestyleNextButton,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Segmented progress bar
                            _buildSegmentedProgressBar(),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                loc.lifestylePageProgress(
                                  currentStep,
                                  totalSteps,
                                ),
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

  // Radio option builder
  Widget _buildRadioOption(
    String label,
    String? groupValue,
    ValueChanged<String?> onChanged,
  ) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(vertical: -3, horizontal: -1),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          color: AppColors.textBlack87,
        ),
      ),
      value: label,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.accentTeal,
    );
  }

  // Segmented progress bar builder
  Widget _buildSegmentedProgressBar() {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isFilled = index < currentStep;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: isFilled ? AppColors.accentTeal : AppColors.progressGrey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
