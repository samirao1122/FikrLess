import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../before_login_signup/choose_yourself.dart';
import '../forget_pasword/forget_password.dart';
import 'login_screen.dart';
import '../../userflow/user_dashboard.dart';

class LoginScreenwithEmail extends StatefulWidget {
  const LoginScreenwithEmail({super.key});

  @override
  State<LoginScreenwithEmail> createState() => _LoginScreenwithEmailState();
}

class _LoginScreenwithEmailState extends State<LoginScreenwithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  final String baseUrl =
      "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/login";

  bool _validateInput() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    bool hasError = false;

    if (email.isEmpty) {
      _emailError = "Please enter your email";
      hasError = true;
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = "Please enter a valid email address";
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = "Please enter your password";
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      hasError = true;
    }

    return !hasError;
  }

  Future<void> _login() async {
    if (!_validateInput()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "Login successful ✅",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF212121),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['error'] ?? "Login failed ❌",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF3E2723),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Network error: $e",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF3E2723),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double getResponsiveHeight(double value) => screenHeight * value;
    double getResponsiveWidth(double value) => screenWidth * value;
    double getResponsiveFont(double value) => screenWidth * value / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: getResponsiveWidth(0.053),
            vertical: getResponsiveHeight(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getResponsiveHeight(0.02)),
              Center(
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: getResponsiveFont(38),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: getResponsiveHeight(0.01)),
              Center(
                child: Text(
                  "To log in to your account please fill the below fields.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getResponsiveFont(19),
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: getResponsiveHeight(0.05)),

              // Email Field
              Text(
                "Email",
                style: TextStyle(
                  fontSize: getResponsiveFont(19),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: getResponsiveHeight(0.008)),
              Container(
                height: getResponsiveHeight(0.065),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _emailError == null ? Colors.black26 : Colors.red,
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveWidth(0.03),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(75, 0, 0, 0),
                      fontSize: getResponsiveFont(16),
                    ),
                  ),
                ),
              ),
              if (_emailError != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: getResponsiveHeight(0.005),
                    left: getResponsiveWidth(0.01),
                  ),
                  child: Text(
                    _emailError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: getResponsiveFont(13),
                    ),
                  ),
                ),

              SizedBox(height: getResponsiveHeight(0.025)),

              // Password Field
              Text(
                "Password",
                style: TextStyle(
                  fontSize: getResponsiveFont(19),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: getResponsiveHeight(0.006)),
              Container(
                height: getResponsiveHeight(0.065),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _passwordError == null ? Colors.black26 : Colors.red,
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveWidth(0.03),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: getResponsiveFont(15),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black38,
                        size: getResponsiveFont(22),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              if (_passwordError != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: getResponsiveHeight(0.005),
                    left: getResponsiveWidth(0.01),
                  ),
                  child: Text(
                    _passwordError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: getResponsiveFont(13),
                    ),
                  ),
                ),

              SizedBox(height: getResponsiveHeight(0.008)),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(
                      getResponsiveWidth(0.12),
                      getResponsiveHeight(0.03),
                    ),
                  ),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: const Color(0xFF00A8A8),
                      fontWeight: FontWeight.w600,
                      fontSize: getResponsiveFont(15),
                    ),
                  ),
                ),
              ),

              SizedBox(height: getResponsiveHeight(0.015)),

              // Log in Button
              SizedBox(
                width: double.infinity,
                height: getResponsiveHeight(0.065),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: getResponsiveFont(20),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: getResponsiveHeight(0.02)),

              // Log in with Phone
              SizedBox(
                width: double.infinity,
                height: getResponsiveHeight(0.065),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Log in with Phone Number",
                    style: TextStyle(
                      fontSize: getResponsiveFont(18),
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: getResponsiveHeight(0.25)),

              // Sign up Link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(
                      fontSize: getResponsiveFont(15),
                      color: Colors.black87,
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseWhoAreYouScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: const Color(0xFF00A8A8),
                              fontWeight: FontWeight.w600,
                              fontSize: getResponsiveFont(20),
                            ),
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
}
