import 'package:flutter/material.dart';
import 'mental_health_goals.dart';
import 'user_survey_data.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class BasicDemographicsScreen extends StatefulWidget {
  final UserSurveyData surveyData;
  final Locale locale; // ✅ Added locale

  const BasicDemographicsScreen({
    super.key,
    required this.surveyData,
    required this.locale, // ✅ require locale
  });

  @override
  State<BasicDemographicsScreen> createState() =>
      _BasicDemographicsScreenState();
}

class _BasicDemographicsScreenState extends State<BasicDemographicsScreen> {
  String? selectedAge;
  String? selectedCountry;
  String? gender;
  String? relationship;

  bool _isLoading = false;

  final int currentStep = 1;
  final int totalSteps = 6;

  late List<String> ages;
  late List<String> countries;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;

    ages = [
      localizations.ageOption1,
      localizations.ageOption2,
      localizations.ageOption3,
      localizations.ageOption4,
    ];

    countries = [
      localizations.countryOption1,
      localizations.countryOption2,
      localizations.countryOption3,
      localizations.countryOption4,
      localizations.countryOption5,
    ];
  }

  Future<void> _submitDemographics() async {
    if (selectedAge == null ||
        gender == null ||
        selectedCountry == null ||
        relationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.termsError),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Save selected values
    widget.surveyData.ageRange = selectedAge;
    widget.surveyData.genderIdentity = gender;
    widget.surveyData.countryOfResidence = selectedCountry;
    widget.surveyData.relationshipStatus = relationship;

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MentalHealthGoalsScreen(
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
          final localizations = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 17, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          localizations.basicDemographicsTitle,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                  color: AppColors.colorBlack,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              localizations.basicDemographicsSubtitle,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack87,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildLabel(localizations.ageLabel),
                            const SizedBox(height: 6),
                            _buildDropdown(
                              hint: localizations.ageOption1,
                              value: selectedAge,
                              items: ages,
                              onChanged: (val) =>
                                  setState(() => selectedAge = val),
                            ),
                            const SizedBox(height: 16),
                            _buildLabel(localizations.genderIdentityLabel),
                            const SizedBox(height: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCheckbox(
                                  localizations.genderMale,
                                  gender == localizations.genderMale,
                                  () => setState(
                                    () => gender = localizations.genderMale,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.genderFemale,
                                  gender == localizations.genderFemale,
                                  () => setState(
                                    () => gender = localizations.genderFemale,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.genderPreferNotToSay,
                                  gender == localizations.genderPreferNotToSay,
                                  () => setState(
                                    () => gender =
                                        localizations.genderPreferNotToSay,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildLabel(localizations.countryLabel),
                            const SizedBox(height: 6),
                            _buildDropdown(
                              hint: localizations.countryOption1,
                              value: selectedCountry,
                              items: countries,
                              onChanged: (val) =>
                                  setState(() => selectedCountry = val),
                            ),
                            const SizedBox(height: 16),
                            _buildLabel(localizations.relationshipStatusLabel),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCheckbox(
                                  localizations.relationshipSingle,
                                  relationship ==
                                      localizations.relationshipSingle,
                                  () => setState(
                                    () => relationship =
                                        localizations.relationshipSingle,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.relationshipInRelationship,
                                  relationship ==
                                      localizations.relationshipInRelationship,
                                  () => setState(
                                    () => relationship = localizations
                                        .relationshipInRelationship,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.relationshipMarried,
                                  relationship ==
                                      localizations.relationshipMarried,
                                  () => setState(
                                    () => relationship =
                                        localizations.relationshipMarried,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.relationshipDivorced,
                                  relationship ==
                                      localizations.relationshipDivorced,
                                  () => setState(
                                    () => relationship =
                                        localizations.relationshipDivorced,
                                  ),
                                ),
                                _buildCheckbox(
                                  localizations.relationshipWidowed,
                                  relationship ==
                                      localizations.relationshipWidowed,
                                  () => setState(
                                    () => relationship =
                                        localizations.relationshipWidowed,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.infoBoxBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.disclaimerTitle,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    localizations.disclaimerDescription,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      height: 1.4,
                                      color: AppColors.textBlack87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : _submitDemographics,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 7,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: AppColors.white,
                                        size: 12,
                                      ),
                                label: Text(
                                  _isLoading
                                      ? localizations.submittingButton
                                      : localizations.nextButton,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildSegmentedProgressBar(),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                localizations.pageProgressText(
                                  currentStep,
                                  totalSteps,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
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
              color: isFilled ? AppColors.primary : AppColors.progressGrey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 15, color: AppColors.textBlack54),
          ),
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textBlack54,
          ),
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textBlack87,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) => onTap(),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(width: 1.3, color: AppColors.borderGrey),
            visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: AppColors.textBlack87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack87,
      ),
    );
  }
}
