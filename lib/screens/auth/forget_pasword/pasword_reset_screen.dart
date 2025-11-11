import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_sucessfully.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String contactValue; // ✅ email or phone
  final bool isPhone;
  final String userId;
  final String token; // ✅ now receiving token from OTP screen

  const ResetPasswordScreen({
    super.key,
    required this.contactValue,
    required this.isPhone,
    required this.userId,
    required this.token, // 👈 added token
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _newPasswordError;
  String? _confirmPasswordError;

  bool _isStrongPassword(String password) {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{4,}$',
    );
    return regex.hasMatch(password);
  }

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    final String newPassword = _newPasswordController.text.trim();
    _confirmPasswordController.text.trim();

    final Uri url = Uri.parse(
      "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/change-password",
    );

    final Map<String, dynamic> requestData = {
      "new_password": newPassword,
      "token": widget.token, // ✅ include token in body
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}', // ✅ also send token header
        },
        body: jsonEncode(requestData),
      );

      debugPrint("🔹 Change Password Response: ${response.body}");
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "Password changed successfully!",
              style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // ✅ Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const reset_sucessfully()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "Failed to change password!",
              style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Change Password Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Network error: $e",
            style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateAndSubmit() {
    setState(() {
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (newPassword.isEmpty) {
      _newPasswordError = "Please enter your new password";
      hasError = true;
    } else if (!_isStrongPassword(newPassword)) {
      _newPasswordError =
          "Password must have 4+ chars, 1 uppercase, 1 number, and 1 special char";
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = "Please confirm your password";
      hasError = true;
    } else if (confirmPassword != newPassword) {
      _confirmPasswordError = "Passwords do not match";
      hasError = true;
    }

    if (!hasError) {
      _changePassword(); // ✅ Call backend
    } else {
      setState(() {}); // Refresh UI for validation messages
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: _h(0.022)), // ~20px
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: _f(36),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF01394F),
                    ),
                  ),
                  SizedBox(height: _h(0.006)), // ~10px
                  Text(
                    "Resetting password for ${widget.contactValue}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: _f(17),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: _h(0.08)), // ~30px
                  // 🔹 New Password Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: _f(14),
                      ),
                    ),
                  ),
                  SizedBox(height: _h(0.021)), // ~8px
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: "Enter your new password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: _w(0.037), // ~14px
                        vertical: _h(0.019), // ~14px
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_w(0.016)), // ~6
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(_w(0.016)),
                        ),
                        borderSide: const BorderSide(
                          color: Color(0xFF00A8A8),
                          width: 1.4,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_w(0.016)),
                        borderSide: BorderSide(
                          color: _newPasswordError == null
                              ? Colors.grey.shade300
                              : Colors.red,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (_newPasswordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: _h(0.007), left: _w(0.011)),
                      child: Text(
                        _newPasswordError!,
                        style: TextStyle(color: Colors.red, fontSize: _f(13)),
                      ),
                    ),
                  SizedBox(height: _h(0.053)), // ~20px
                  // 🔹 Confirm Password Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm New Password",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: _f(14),
                      ),
                    ),
                  ),
                  SizedBox(height: _h(0.011)), // ~8px
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Re-enter your password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: _w(0.037),
                        vertical: _h(0.019),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_w(0.016)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(_w(0.016)),
                        ),
                        borderSide: const BorderSide(
                          color: Color(0xFF00A8A8),
                          width: 1.4,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_w(0.016)),
                        borderSide: BorderSide(
                          color: _confirmPasswordError == null
                              ? Colors.grey.shade300
                              : Colors.red,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (_confirmPasswordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: _h(0.007), left: _w(0.011)),
                      child: Text(
                        _confirmPasswordError!,
                        style: TextStyle(color: Colors.red, fontSize: _f(13)),
                      ),
                    ),

                  SizedBox(height: _h(0.05)), // ~30px
                  // 🔹 Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A8A8),
                        padding: EdgeInsets.symmetric(vertical: _h(0.017)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_w(0.016)),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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
                  SizedBox(height: _h(0.106)), // ~40px
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
