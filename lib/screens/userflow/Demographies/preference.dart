import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Consent&Safety.dart'; // ✅ Next screen
import 'user_survey_data.dart'; // ✅ Shared model
import '../../../theme/app_colors.dart'; // ✅ Centralized colors
import '../../../l10n/app_localizations.dart'; // ✅ Localization

class PreferencesScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ Receive previous data
  final Locale locale; // ✅ Added locale field

  const PreferencesScreen({
    super.key,
    required this.surveyData,
    required this.locale,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? selectedSupportType;
  String? therapistPreference;
  String? selectedLanguage;

  final int totalSteps = 6;
  final int currentStep = 5;

  final List<String> supportOptions = [
    "Self–help tools (journaling, meditation, exercises)",
    "Chat with a professional",
    "Video/voice therapy",
    "Peer community support",
  ];

  final List<String> therapistOptions = ["Male", "Female", "No preference"];
  final List<String> languages = ["English", "Urdu"];

  void _onNext() {
    // ✅ Save answers into shared UserSurveyData
    widget.surveyData.preferredSupportType = [
      if (selectedSupportType != null) selectedSupportType!,
    ];
    widget.surveyData.preferredTherapistGender = therapistPreference;
    widget.surveyData.preferredLanguage = selectedLanguage;

    // ✅ Navigate to next screen with same surveyData and locale
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConsentSafetyScreen(
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
      locale: widget.locale, // ✅ Override localization
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr, // ✅ LTR/RTL support
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? CupertinoIcons.back
                                    : Icons.arrow_back_rounded,
                                color: AppColors.accentTeal,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                loc.preferencesTitle,
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

                      // Main card
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
                            // Divider
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

                            // Preferred support type
                            Text(
                              loc.preferredSupportTypeLabel,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...supportOptions.map(
                              (option) => _buildRadioOption(
                                option == supportOptions[0]
                                    ? loc.supportOptionSelfHelp
                                    : option == supportOptions[1]
                                    ? loc.supportOptionChatProfessional
                                    : option == supportOptions[2]
                                    ? loc.supportOptionVideoTherapy
                                    : loc.supportOptionPeerSupport,
                                selectedSupportType,
                                (val) =>
                                    setState(() => selectedSupportType = val),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Therapist preference
                            Text(
                              loc.preferredTherapistLabel,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...therapistOptions.map(
                              (option) => _buildRadioOption(
                                option == "Male"
                                    ? loc.therapistOptionMale
                                    : option == "Female"
                                    ? loc.therapistOptionFemale
                                    : loc.therapistOptionNoPreference,
                                therapistPreference,
                                (val) =>
                                    setState(() => therapistPreference = val),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Preferred language
                            Text(
                              loc.preferredLanguageLabel,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.borderGrey300,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedLanguage,
                                  hint: Text(loc.selectLanguageHint),
                                  isExpanded: true,
                                  items: languages
                                      .map(
                                        (lang) => DropdownMenuItem(
                                          value: lang == "English"
                                              ? loc.languageOptionEnglish
                                              : loc.languageOptionUrdu,
                                          child: Text(
                                            lang == "English"
                                                ? loc.languageOptionEnglish
                                                : loc.languageOptionUrdu,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => selectedLanguage = val),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

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
                                  loc.nextButton,
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

                            // Progress bar
                            _buildSegmentedProgressBar(),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                loc.stepProgress(currentStep, totalSteps),
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
