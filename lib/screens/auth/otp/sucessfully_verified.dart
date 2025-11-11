import 'package:flutter/material.dart';

import "../../userflow/Demographies/basic_info_screen.dart";
import "../../userflow/Demographies/user_survey_data.dart"
    show UserSurveyData; // ⬅️ import your demographics setup screen
import '../../specialistflow/Demographies/basic_information.dart'; // Import for specialist role

class userVerifiedScreen extends StatelessWidget {
  final String contactValue;
  final bool isPhone;
  final String userId;
  final String role; // ✅ added role

  const userVerifiedScreen({
    super.key,
    required this.contactValue,
    required this.isPhone,
    required this.userId,
    required this.role, // ✅ added role
  });

  // 🧩 Function to hide sensitive info
  String _maskContact(String contact) {
    if (isPhone) {
      if (contact.length > 6) {
        return contact.replaceRange(
          contact.length - 8,
          contact.length - 4,
          "****",
        );
      } else {
        return contact;
      }
    } else {
      final parts = contact.split('@');
      if (parts.length == 2 && parts[0].length > 3) {
        final prefix = parts[0].substring(0, 3);
        return '$prefix***@${parts[1]}';
      } else {
        return contact;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedContact = _maskContact(contactValue);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/otp_screen/tick.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Successfully Verified',
                  style: TextStyle(
                    color: Color(0xFF00C853),
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Your ${isPhone ? "phone number" : "email"} $maskedContact\nhas been verified successfully.\nYou can now continue with log in.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (role.toLowerCase() == "user") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BasicDemographicsScreen(
                              surveyData: UserSurveyData(userId: userId),
                            ),
                          ),
                        );
                      } else if (role.toLowerCase() == "specialist") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BasicInformationScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Set up Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
