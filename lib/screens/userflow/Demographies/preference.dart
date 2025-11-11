import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Consent&Safety.dart'; // ✅ Step 6
import 'user_survey_data.dart'; // ✅ Shared model

class PreferencesScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ Correct type
  const PreferencesScreen({super.key, required this.surveyData});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? selectedSupportType;
  String? therapistPreference;
  String? selectedLanguage;

  final int totalSteps = 6;
  final int currentStep = 5; // Step 5 of 6

  final List<String> supportOptions = [
    "Self–help tools (journaling, meditation, exercises)",
    "Chat with a professional",
    "Video/voice therapy",
    "Peer community support",
  ];

  final List<String> therapistOptions = ["Male", "Female", "No preference"];
  final List<String> languages = ["English", "Urdu"];

  void _onNext() {
    // ✅ Save answers into the main UserSurveyData object
    widget.surveyData.preferredSupportType = [
      if (selectedSupportType != null) selectedSupportType!,
    ];
    widget.surveyData.preferredTherapistGender = therapistPreference;
    widget.surveyData.preferredLanguage = selectedLanguage;

    // ✅ Go to Step 6
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConsentSafetyScreen(surveyData: widget.surveyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
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
                        color: const Color(0xFF00A8A8),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Preferences",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00A8A8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Main Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider bar
                    Center(
                      child: Container(
                        width: 120,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Preferred type of support
                    const Text(
                      "Preferred type of support:",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...supportOptions.map(
                      (option) => _buildRadioOption(
                        option,
                        selectedSupportType,
                        (val) => setState(() => selectedSupportType = val),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Therapist preference
                    const Text(
                      "Preferred therapist characteristics:",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...therapistOptions.map(
                      (option) => _buildRadioOption(
                        option,
                        therapistPreference,
                        (val) => setState(() => therapistPreference = val),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Preferred language
                    const Text(
                      "Preferred language:",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLanguage,
                          hint: const Text("Select language"),
                          isExpanded: true,
                          items: languages
                              .map(
                                (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Text(lang),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedLanguage = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Next Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8A8),
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
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Progress Bar
                    _buildSegmentedProgressBar(),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Step $currentStep of $totalSteps",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          color: Colors.black54,
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
    );
  }

  // Radio Button Builder
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
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      value: label,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: const Color(0xFF00A8A8),
    );
  }

  // Segmented Progress Bar
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
              color: isFilled ? const Color(0xFF00A8A8) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
