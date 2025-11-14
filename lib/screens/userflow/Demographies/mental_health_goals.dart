import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'current_mental_health_status.dart';
import 'user_survey_data.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class MentalHealthGoalsScreen extends StatefulWidget {
  final UserSurveyData surveyData;
  final Locale locale; // ✅ added locale to pass down

  const MentalHealthGoalsScreen({
    super.key,
    required this.surveyData,
    required this.locale, // ✅ require locale
  });

  @override
  State<MentalHealthGoalsScreen> createState() =>
      _MentalHealthGoalsScreenState();
}

class _MentalHealthGoalsScreenState extends State<MentalHealthGoalsScreen> {
  List<String> selectedReasons = [];
  List<String> selectedGoals = [];
  final TextEditingController otherController = TextEditingController();

  final int totalSteps = 6;
  final int currentStep = 2;

  late final List<String> reasons;
  late final List<String> goals;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;

    reasons = [
      localizations.mentalHealthReasonAnxiety,
      localizations.mentalHealthReasonDepression,
      localizations.mentalHealthReasonRelationship,
      localizations.mentalHealthReasonTrauma,
      localizations.mentalHealthReasonSelfEsteem,
      localizations.mentalHealthReasonWork,
      localizations.mentalHealthReasonOther,
    ];

    goals = [
      localizations.mentalHealthGoalReduceStress,
      localizations.mentalHealthGoalImproveMood,
      localizations.mentalHealthGoalHealthyHabits,
      localizations.mentalHealthGoalCoping,
      localizations.mentalHealthGoalTalkProfessional,
      localizations.mentalHealthGoalPersonalGrowth,
    ];
  }

  void _toggleReason(String reason) {
    setState(() {
      if (selectedReasons.contains(reason)) {
        selectedReasons.remove(reason);
      } else {
        selectedReasons.add(reason);
      }
    });
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else if (selectedGoals.length < 2) {
        selectedGoals.add(goal);
      }
    });
  }

  void _onNext() {
    final localizations = AppLocalizations.of(context)!;

    if (selectedReasons.isEmpty || selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.mentalHealthSelectError),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Save selections to surveyData
    widget.surveyData.whatBringsYouHere = selectedReasons;
    widget.surveyData.otherReason =
        selectedReasons.contains(localizations.mentalHealthReasonOther)
        ? otherController.text
        : "";
    widget.surveyData.goalsForUsingApp = selectedGoals;

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CurrentMentalHealthStatusScreen(
          surveyData: widget.surveyData,
          locale: widget.locale, // ✅ pass locale forward
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              backgroundColor: AppColors.scaffoldBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
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
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                localizations.mentalHealthGoalsTitle,
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25),
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
                            Center(
                              child: Container(
                                width: 145,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.dividerBar,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              localizations.mentalHealthReasonsTitle,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...reasons.map((reason) {
                              if (reason ==
                                  localizations.mentalHealthReasonOther) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCheckbox(
                                      reason,
                                      selectedReasons.contains(reason),
                                      () => _toggleReason(reason),
                                    ),
                                    if (selectedReasons.contains(reason))
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6,
                                          left: 36,
                                        ),
                                        child: TextField(
                                          controller: otherController,
                                          decoration: InputDecoration(
                                            hintText: localizations
                                                .mentalHealthOtherHint,
                                            filled: true,
                                            fillColor:
                                                AppColors.scaffoldBackground,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: AppColors.borderGrey300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }
                              return _buildCheckbox(
                                reason,
                                selectedReasons.contains(reason),
                                () => _toggleReason(reason),
                              );
                            }),
                            const SizedBox(height: 25),
                            Text(
                              localizations.mentalHealthGoalsSectionTitle,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...goals.map(
                              (goal) => _buildCheckbox(
                                goal,
                                selectedGoals.contains(goal),
                                () => _toggleGoal(goal),
                              ),
                            ),
                            const SizedBox(height: 30),
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
                                  localizations.mentalHealthNextButton,
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
                                localizations.mentalHealthPageProgress(
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
              activeColor: AppColors.accentTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(width: 1.3, color: AppColors.borderGrey),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
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
