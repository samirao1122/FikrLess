import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class reset_sucessfully extends StatelessWidget {
  const reset_sucessfully({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Helper functions for responsive sizing
    double h(double value) => screenHeight * value; // height
    double w(double value) => screenWidth * value; // width
    double f(double value) =>
        screenWidth * value / 375; // font size scaling based on 375 width

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w(0.085),
            ), // ~32px on base 375 width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Success Tick Image
                Image.asset(
                  'assets/images/otp_screen/tick.png',
                  width: w(0.24), // ~90px
                  height: w(0.24),
                  fit: BoxFit.contain,
                ),

                SizedBox(height: h(0.015)), // ~12px
                // ✅ Title
                Text(
                  'Successfully Verified',
                  style: TextStyle(
                    color: const Color(0xFF00C853),
                    fontSize: f(38),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h(0.024)), // ~18px
                // ✅ Description
                Text(
                  'Your phone number +82 304 **** 678 has been\nverified successfully. You can now\ncontinue with log in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: f(17),
                    height: 1.6,
                  ),
                ),

                SizedBox(height: h(0.106)), // ~40px
                // ✅ Login Button
                SizedBox(
                  width: double.infinity,
                  height: h(0.065), // ~50px
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: f(19),
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
