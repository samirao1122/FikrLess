import 'package:flutter/material.dart';
import '../auth/signup/signup_with_phone.dart' show userSignUpScreen;

class ChooseWhoAreYouScreen extends StatelessWidget {
  const ChooseWhoAreYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive text scaling
    final textScale = (screenWidth / 390).clamp(0.85, 1.15);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Image
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Image.asset(
                              'assets/images/before_login/get_started_screen.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Section
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: 20,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Handle bar
                              Center(
                                child: Container(
                                  width: screenWidth * 0.4,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      27,
                                      27,
                                      27,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Title
                              Text(
                                "Choose Who Are You?",
                                style: TextStyle(
                                  fontSize: 39 * textScale,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),

                              // Subtitle
                              Text(
                                "Kindly choose according to your role to proceed the sign up.",
                                style: TextStyle(
                                  fontSize: 20 * textScale,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),

                              // Specialist Button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userSignUpScreen(role: 'specialist'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A8A8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  "Sign up as a Specialist",
                                  style: TextStyle(
                                    fontSize: 19 * textScale,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),

                              // User Button
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userSignUpScreen(role: 'user'),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF00A8A8),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  "Sign up as a User",
                                  style: TextStyle(
                                    fontSize: 19 * textScale,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF00A8A8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
