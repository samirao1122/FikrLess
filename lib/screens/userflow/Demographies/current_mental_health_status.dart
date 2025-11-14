import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'lifeStyle&Support.dart';
import 'user_survey_data.dart';
import '../../../theme/app_colors.dart'; // ✅ Import AppColors
import '../../../l10n/app_localizations.dart'; // ✅ Import localization

class CurrentMentalHealthStatusScreen extends StatefulWidget {
  final UserSurveyData surveyData;
  final Locale locale; // ✅ Added locale to pass forward

  const CurrentMentalHealthStatusScreen({
    super.key,
    required this.surveyData,
    required this.locale, // ✅ require locale
  });

  @override
  State<CurrentMentalHealthStatusScreen> createState() =>
      _CurrentMentalHealthStatusScreenState();
}

class _CurrentMentalHealthStatusScreenState
    extends State<CurrentMentalHealthStatusScreen> {
  final int totalSteps = 6;
  int currentStep = 3;

  String? diagnosed;
  List<String> followUpSelections = [];
  String? seeingProfessional;
  String? suicidalThoughts;

  late final List<String> followUpOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = AppLocalizations.of(context)!;
    followUpOptions = [
      locale.followUpPersistentSadness,
      locale.followUpPanicAttacks,
      locale.followUpSleepDifficulty,
      locale.followUpLossInterest,
      locale.followUpConcentrationDifficulty,
      locale.followUpNone,
    ];
  }

  void _toggleFollowUp(String option) {
    setState(() {
      if (followUpSelections.contains(option)) {
        followUpSelections.remove(option);
      } else {
        followUpSelections.add(option);
      }
    });
  }

  void _onNext() {
    widget.surveyData.mentalHealthDiagnosis = diagnosed;
    widget.surveyData.diagnosedConditions = followUpSelections;
    widget.surveyData.seeingProfessional = seeingProfessional;
    widget.surveyData.suicidalThoughts = suicidalThoughts;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LifestyleSupportScreen(
          surveyData: widget.surveyData,
          locale: widget.locale, // ✅ pass locale forward
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Row(
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
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: MaterialStateProperty.all(
                                  const Size(40, 40),
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                locale.currentMentalHealthTitle,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 22,
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
                            const SizedBox(height: 25),
                            Text(
                              locale.mentalHealthDiagnosisQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildRadio(
                              locale.diagnosedYes,
                              diagnosed,
                              (val) => setState(() => diagnosed = val),
                            ),
                            _buildRadio(
                              locale.diagnosedNo,
                              diagnosed,
                              (val) => setState(() => diagnosed = val),
                            ),
                            _buildRadio(
                              locale.diagnosedPreferNot,
                              diagnosed,
                              (val) => setState(() => diagnosed = val),
                            ),
                            if (diagnosed == locale.diagnosedYes) ...[
                              const SizedBox(height: 18),
                              Text(
                                locale.mentalHealthFollowUpQuestion,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...followUpOptions.map(
                                (opt) => _buildCheckbox(
                                  opt,
                                  followUpSelections.contains(opt),
                                  () => _toggleFollowUp(opt),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Text(
                              locale.seeingProfessionalQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildRadio(
                              locale.diagnosedYes,
                              seeingProfessional,
                              (val) => setState(() => seeingProfessional = val),
                            ),
                            _buildRadio(
                              locale.diagnosedNo,
                              seeingProfessional,
                              (val) => setState(() => seeingProfessional = val),
                            ),
                            _buildRadio(
                              locale.seeingProfessionalNone,
                              seeingProfessional,
                              (val) => setState(() => seeingProfessional = val),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              locale.suicidalThoughtsQuestion,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildRadio(
                              locale.suicidalYesRecent,
                              suicidalThoughts,
                              (val) => setState(() => suicidalThoughts = val),
                            ),
                            _buildRadio(
                              locale.suicidalYesPast,
                              suicidalThoughts,
                              (val) => setState(() => suicidalThoughts = val),
                            ),
                            _buildRadio(
                              locale.suicidalNever,
                              suicidalThoughts,
                              (val) => setState(() => suicidalThoughts = val),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
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
                                  locale.currentMentalHealthNextButton,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildSegmentedProgressBar(),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                locale.currentMentalHealthPageProgress(
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

  Widget _buildCheckbox(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(width: 1.3, color: AppColors.borderGrey),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: AppColors.textBlack87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(
    String title,
    String? groupValue,
    ValueChanged<String?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Radio<String>(
              value: title,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: AppColors.textBlack87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
