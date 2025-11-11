import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'lifeStyle&Support.dart';
import 'user_survey_data.dart'; // ✅ Import model

class CurrentMentalHealthStatusScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ receive data

  const CurrentMentalHealthStatusScreen({super.key, required this.surveyData});

  @override
  State<CurrentMentalHealthStatusScreen> createState() =>
      _CurrentMentalHealthStatusScreenState();
}

class _CurrentMentalHealthStatusScreenState
    extends State<CurrentMentalHealthStatusScreen> {
  final int totalSteps = 6;
  int currentStep = 3; // Step 3 of 6

  String? diagnosed;
  List<String> followUpSelections = [];
  String? seeingProfessional;
  String? suicidalThoughts;

  final List<String> followUpOptions = const [
    "Persistent sadness",
    "Panic attacks",
    "Difficulty sleeping",
    "Loss of interest in activities",
    "Difficulty concentrating",
    "None of the above",
  ];

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
    // ✅ Update survey data with selected values
    widget.surveyData.mentalHealthDiagnosis = diagnosed;
    widget.surveyData.diagnosedConditions = followUpSelections;
    widget.surveyData.seeingProfessional = seeingProfessional;
    widget.surveyData.suicidalThoughts = suicidalThoughts;

    // ✅ Navigate to next screen with updated data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LifestyleSupportScreen(surveyData: widget.surveyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
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
                        color: const Color(0xFF00A8A8),
                        size: 26,
                      ),
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(
                          const Size(40, 40),
                        ),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Current Mental Health Status",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00A8A8),
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
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
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
                    Center(
                      child: Container(
                        width: 145,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      "Have you ever been diagnosed with a mental health condition?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRadio("Yes", diagnosed, (val) {
                      setState(() => diagnosed = val);
                    }),
                    _buildRadio("No", diagnosed, (val) {
                      setState(() => diagnosed = val);
                    }),
                    _buildRadio("Prefer not to say", diagnosed, (val) {
                      setState(() => diagnosed = val);
                    }),

                    if (diagnosed == "Yes") ...[
                      const SizedBox(height: 18),
                      const Text(
                        "Follow-up: Which one(s)?",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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

                    const Text(
                      "Are you currently seeing a mental health professional?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRadio("Yes", seeingProfessional, (val) {
                      setState(() => seeingProfessional = val);
                    }),
                    _buildRadio("No", seeingProfessional, (val) {
                      setState(() => seeingProfessional = val);
                    }),
                    _buildRadio("None of the above", seeingProfessional, (val) {
                      setState(() => seeingProfessional = val);
                    }),

                    const SizedBox(height: 20),

                    const Text(
                      "Have you ever had suicidal thoughts or self-harm behaviors?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRadio("Yes (recently)", suicidalThoughts, (val) {
                      setState(() => suicidalThoughts = val);
                    }),
                    _buildRadio("Yes (in the past)", suicidalThoughts, (val) {
                      setState(() => suicidalThoughts = val);
                    }),
                    _buildRadio("Never", suicidalThoughts, (val) {
                      setState(() => suicidalThoughts = val);
                    }),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _onNext, // ✅ updated
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

                    const SizedBox(height: 25),
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
              activeColor: const Color(0xFF00A8A8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(width: 1.3, color: Colors.grey),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.black87,
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
              activeColor: const Color(0xFF00A8A8),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
