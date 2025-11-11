import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../auth/login/login_screen.dart';
import 'user_survey_data.dart'; // ✅ correct import

class ConsentSafetyScreen extends StatefulWidget {
  final UserSurveyData surveyData;

  const ConsentSafetyScreen({super.key, required this.surveyData});

  @override
  State<ConsentSafetyScreen> createState() => _ConsentSafetyScreenState();
}

class _ConsentSafetyScreenState extends State<ConsentSafetyScreen> {
  bool agree = false;

  final int totalSteps = 6;
  final int currentStep = 6;

  // ✅ Submit all survey data to backend
  Future<void> _submitData() async {
    widget.surveyData.understandsEmergencyDisclaimer = agree;

    try {
      final url = Uri.parse(
        'https://stalagmitical-millie-unhomiletic.ngrok-free.dev/demographics',
      );

      // ✅ Use the actual userId from surveyData
      final Map<String, dynamic> payload = widget.surveyData.toJson();
      if (widget.surveyData.userId != null) {
        payload["user_id"] = widget.surveyData.userId;
      } else {
        debugPrint("⚠️ Warning: userId is null in surveyData!");
      }

      // Debug print — shows full payload in console
      print("📦 Sending payload: ${jsonEncode(payload)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Survey submitted successfully!')),
        );

        // Wait briefly before navigation
        await Future.delayed(const Duration(seconds: 1));

        // ✅ Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to submit survey (${response.statusCode}): ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting survey: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                      color: const Color(0xFF00A8A8),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Consent & Safety",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00A8A8),
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
                      // Handle bar
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
                      const SizedBox(height: 40),

                      // Consent Text
                      const Text(
                        "I understand this app does not replace emergency medical services.",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 22),

                      CheckboxListTile(
                        value: agree,
                        onChanged: (val) =>
                            setState(() => agree = val ?? false),
                        activeColor: const Color(0xFF00A8A8),
                        title: const Text(
                          "Yes, I agree",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 35),

                      // Safety message
                      const Text(
                        "If you ever feel unsafe or have thoughts of self-harm, "
                        "please contact your local emergency number immediately.",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),

                      // Submit / Go to Login button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: agree ? _submitData : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A8A8),
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Submit & Go to Login",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Progress bar
                      _buildSegmentedProgressBar(),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          "Page 6 of 6",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.black54,
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
    );
  }

  // Progress Bar
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
