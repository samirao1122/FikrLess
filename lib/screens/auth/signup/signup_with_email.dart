import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../otp/otp_signup.dart'; // Make sure this import path is correct
import 'signup_with_phone.dart';
import '../login/login_screen.dart';

class UserSignUpScreenEmail extends StatefulWidget {
  final String role;
  const UserSignUpScreenEmail({super.key, required this.role});

  @override
  State<UserSignUpScreenEmail> createState() => _UserSignUpScreenEmailState();
}

class _UserSignUpScreenEmailState extends State<UserSignUpScreenEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;
  bool _showTermsError = false;

  final _formKey = GlobalKey<FormState>();

  // ✅ Handle signup logic
  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _passwordError = null;
      _showTermsError = false;
    });

    bool valid = true;

    if (_emailController.text.isEmpty) {
      _emailError = "Please enter your email";
      valid = false;
    } else if (!_emailController.text.contains('@')) {
      _emailError = "Enter a valid email address";
      valid = false;
    }

    if (_passwordController.text.isEmpty) {
      _passwordError = "Please enter password";
      valid = false;
    } else if (_passwordController.text.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      valid = false;
    }

    if (!_agreeToTerms) {
      _showTermsError = true;
      valid = false;
    }

    setState(() {});
    if (!valid) return;

    final url = Uri.parse(
      "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/signup",
    );

    try {
      setState(() => _isLoading = true);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'user_type': widget.role,
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserOtpVerificationScreen(
              email: _emailController.text.trim(),
              role: widget.role,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        _showError("This email is already registered. Please log in instead.");
      } else {
        _showError(data['message'] ?? "Signup failed. Try again.");
      }
    } catch (e) {
      if (mounted) _showError("Network error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double h(double val) => screenHeight * val;
    double w(double val) => screenWidth * val;
    double f(double val) => screenWidth * val / 375; // base width

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w(0.05), vertical: h(0.03)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h(0.04)),
                Center(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: f(38),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: h(0.01)),
                Center(
                  child: Text(
                    "To register your account, fill the fields below\nto access full features of this app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: f(17),
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: h(0.03)),

                // Email
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: f(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h(0.005)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: h(0.065),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _emailError != null
                          ? Colors.redAccent
                          : Colors.black26,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: w(0.03)),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: f(17),
                      ),
                    ),
                  ),
                ),
                if (_emailError != null) ...[
                  SizedBox(height: h(0.005)),
                  Text(
                    _emailError!,
                    style: TextStyle(color: Colors.redAccent, fontSize: f(14)),
                  ),
                ],

                SizedBox(height: h(0.02)),

                // Password
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: f(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h(0.005)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: h(0.065),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _passwordError != null
                          ? Colors.redAccent
                          : Colors.black26,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: w(0.03)),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: f(17),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black38,
                        ),
                        onPressed: () {
                          setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (_passwordError != null) ...[
                  SizedBox(height: h(0.005)),
                  Text(
                    _passwordError!,
                    style: TextStyle(color: Colors.redAccent, fontSize: f(14)),
                  ),
                ],

                SizedBox(height: h(0.015)),

                // Terms
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (val) =>
                          setState(() => _agreeToTerms = val ?? false),
                      activeColor: const Color(0xFF00A8A8),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree with ",
                          style: TextStyle(
                            fontSize: f(15),
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms & Policy",
                              style: TextStyle(
                                fontSize: f(15),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00A8A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showTermsError)
                  Padding(
                    padding: EdgeInsets.only(left: w(0.01), bottom: h(0.005)),
                    child: Text(
                      "Please agree to Terms & Policy",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: f(14),
                      ),
                    ),
                  ),

                SizedBox(height: h(0.02)),

                // Sign up button
                SizedBox(
                  width: double.infinity,
                  height: h(0.065),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: f(17),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: h(0.015)),

                // Sign up with phone
                SizedBox(
                  width: double.infinity,
                  height: h(0.065),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => userSignUpScreen(role: widget.role),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      "Sign up with Phone Number",
                      style: TextStyle(
                        fontSize: f(16),
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h(0.05)),

                // Already have account
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: f(15),
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              fontSize: f(15),
                              color: const Color(0xFF00A8A8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h(0.05)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
