import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'current_mental_health_status.dart';
import 'user_survey_data.dart';

class MentalHealthGoalsScreen extends StatefulWidget {
  final UserSurveyData surveyData; // ✅ receive shared survey data

  const MentalHealthGoalsScreen({super.key, required this.surveyData});

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

  final List<String> reasons = [
    'Anxiety or stress',
    'Depression or low mood',
    'Relationship or family issues',
    'Trauma or grief',
    'Self-esteem or confidence',
    'Work or academic stress',
    'Other (free text)',
  ];

  final List<String> goals = [
    'Reduce stress/anxiety',
    'Improve mood & motivation',
    'Build healthy habits (sleep, journaling, exercise)',
    'Learn coping strategies',
    'Talk to a professional',
    'Personal growth / mindfulness',
  ];

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
    if (selectedReasons.isEmpty || selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one reason and one goal."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // ✅ Update shared UserSurveyData
    widget.surveyData.whatBringsYouHere = selectedReasons;
    widget.surveyData.otherReason =
        selectedReasons.contains('Other (free text)')
        ? otherController.text
        : "";
    widget.surveyData.goalsForUsingApp = selectedGoals;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CurrentMentalHealthStatusScreen(surveyData: widget.surveyData),
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
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Mental Health Goals",
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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
                      "What brings you here today?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🧠 Reasons List
                    ...reasons.map((reason) {
                      if (reason == 'Other (free text)') {
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
                                    hintText: "Please specify...",
                                    filled: true,
                                    fillColor: const Color(0xFFF7F9FB),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
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

                    const Text(
                      "What are your goals for using this app? (Select top 2)",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
