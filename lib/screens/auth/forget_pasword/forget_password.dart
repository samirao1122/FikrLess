import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../otp/otp_reset_pasword.dart'; // your OTP verification screen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  bool _isValidEmail(String input) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  Future<void> _submitForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      'https://stalagmitical-millie-unhomiletic.ngrok-free.dev/forgot-password',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text.trim()}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'OTP sent successfully!',
              style: TextStyle(fontSize: _f(14)),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpForPaswordReset(email: _emailController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['error'] ?? 'Failed to send OTP.',
              style: TextStyle(fontSize: _f(14)),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Network error: $e',
            style: TextStyle(fontSize: _f(14)),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ⚡ Responsive helpers
  late double _screenHeight;
  late double _screenWidth;

  double _h(double value) => _screenHeight * value;
  double _w(double value) => _screenWidth * value;
  double _f(double value) => _screenWidth * value / 375; // scale font

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _w(0.064)), // ~24px
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: _h(0.04)), // ~30px
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: _f(36),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF01394F),
                      ),
                    ),
                    SizedBox(height: _h(0.016)), // ~10px
                    Text(
                      "Enter your registered email address to receive a reset code.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: _f(17),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: _h(0.08)), // ~30px
                    // 📨 Email Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: _f(14),
                        ),
                      ),
                    ),
                    SizedBox(height: _h(0.021)), // ~8px
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email address",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: _w(0.037), // ~14px
                          vertical: _h(0.019), // ~14px
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_w(0.016)), // ~6
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_w(0.016)),
                          borderSide: const BorderSide(
                            color: Color(0xFF00A8A8),
                            width: 1.4,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!_isValidEmail(value.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: _h(0.08)), // ~30px
                    // ✅ Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForgotPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8A8),
                          padding: EdgeInsets.symmetric(vertical: _h(0.037)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_w(0.016)),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: _f(16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: _h(0.021)), // ~10px
                    // Back Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: _h(0.037)),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_w(0.016)),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: _f(16),
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _h(0.106)), // ~40px
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
