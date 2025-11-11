import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_survey_data.dart'; // ✅ use the shared model
import 'preference.dart'; // ✅ Step 5

class LifestyleSupportScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ Correct type

  const LifestyleSupportScreen({super.key, required this.surveyData});

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
    // ✅ Save answers into shared UserSurveyData
    widget.surveyData.exerciseFrequency = exerciseFrequency;
    widget.surveyData.substanceUse = substanceUse;
    widget.surveyData.supportSystem = supportSystem;

    // ✅ Move to the next screen, pass the same surveyData
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreferencesScreen(surveyData: widget.surveyData),
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
                        color: const Color(0xFF00A8A8),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Lifestyle & Support",
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

              // Card
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

                    // Exercise Frequency
                    const Text(
                      "How often do you exercise?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRadioOption(
                      "Never",
                      exerciseFrequency,
                      (val) => setState(() => exerciseFrequency = val),
                    ),
                    _buildRadioOption(
                      "Occasionally",
                      exerciseFrequency,
                      (val) => setState(() => exerciseFrequency = val),
                    ),
                    _buildRadioOption(
                      "Weekly",
                      exerciseFrequency,
                      (val) => setState(() => exerciseFrequency = val),
                    ),
                    _buildRadioOption(
                      "Daily",
                      exerciseFrequency,
                      (val) => setState(() => exerciseFrequency = val),
                    ),
                    const SizedBox(height: 20),

                    // Substance Use
                    const Text(
                      "How often do you use alcohol or substances?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRadioOption(
                      "Never",
                      substanceUse,
                      (val) => setState(() => substanceUse = val),
                    ),
                    _buildRadioOption(
                      "Occasionally",
                      substanceUse,
                      (val) => setState(() => substanceUse = val),
                    ),
                    _buildRadioOption(
                      "Frequently",
                      substanceUse,
                      (val) => setState(() => substanceUse = val),
                    ),
                    const SizedBox(height: 20),

                    // Support System
                    const Text(
                      "Do you have a strong support system (family/friends)?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRadioOption(
                      "Yes",
                      supportSystem,
                      (val) => setState(() => supportSystem = val),
                    ),
                    _buildRadioOption(
                      "Somewhat",
                      supportSystem,
                      (val) => setState(() => supportSystem = val),
                    ),
                    _buildRadioOption(
                      "No",
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

                    // Progress bar
                    _buildSegmentedProgressBar(),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Page $currentStep of $totalSteps",
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

  Widget _buildSegmentedProgressBar() {
    return Row(
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
