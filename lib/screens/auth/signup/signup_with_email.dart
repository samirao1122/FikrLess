import 'package:fikr_less/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../otp/otp_signup.dart';
import 'signup_with_phone.dart';
import '../login/login_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import 'package:fikr_less/services/api_service.dart';

class UserSignUpScreenEmail extends StatefulWidget {
  final String role;
  final Locale locale;
  const UserSignUpScreenEmail({
    super.key,
    required this.role,
    required this.locale,
  });

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

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _passwordError = null;
      _showTermsError = false;
    });

    bool valid = true;

    final loc = AppLocalizations.of(context)!;

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _emailError = loc.emailHint;
      valid = false;
    }

    if (_passwordController.text.isEmpty) {
      _passwordError = loc.passwordErrorEmpty;
      valid = false;
    } else if (_passwordController.text.length < 6) {
      _passwordError = loc.passwordErrorShort;
      valid = false;
    }

    if (!_agreeToTerms) {
      _showTermsError = true;
      valid = false;
    }

    setState(() {});
    if (!valid) return;

    final url = Uri.parse(
      "$baseUrlSignUP/signup",
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
              locale: widget.locale,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        _showError(loc.loginLink);
      } else {
        _showError(data['message'] ?? loc.signupButton);
      }
    } catch (e) {
      if (mounted) _showError("${loc.routeNotFound}: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          final textScale = (screenWidth / 390).clamp(0.85, 1.15);

          final fieldHeight = (screenHeight * 0.07).clamp(50.0, 60.0);

          return Scaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      Center(
                        child: Text(
                          loc.signupTitle,
                          style: TextStyle(
                            fontSize: 38 * textScale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorBlack,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      Center(
                        child: Text(
                          loc.signupSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19 * textScale,
                            color: AppColors.textHint,
                            height: 1.6,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Email Label
                      Text(
                        loc.emailHint,
                        style: TextStyle(
                          fontSize: 18 * textScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorBlack,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Email Field
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  height: fieldHeight,
  decoration: BoxDecoration(
    border: Border.all(
      color: _emailError != null
          ? AppColors.errorRed
          : AppColors.borderLight,
      width: 1.3,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.symmetric(
    horizontal: screenWidth * 0.03,
  ),
  child: Center( // ⬅️ this centers the whole TextFormField vertically
    child: TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: loc.emailHint,
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 17 * textScale,
        ),
        contentPadding: EdgeInsets.zero, // no extra vertical padding
      ),
    ),
  ),
),

if (_emailError != null) ...[
  SizedBox(height: screenHeight * 0.006),
  Text(
    _emailError!,
    style: TextStyle(
      color: AppColors.errorRed,
      fontSize: 14 * textScale,
    ),
  ),
],

                      SizedBox(height: screenHeight * 0.02),

                      // Password Label
                      Text(
                        loc.passwordLabel,
                        style: TextStyle(
                          fontSize: 18 * textScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorBlack,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Password Field
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: fieldHeight,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _passwordError != null
                                ? AppColors.errorRed
                                : AppColors.borderLight,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              height: 1.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: loc.passwordHint,
                              hintStyle: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 17 * textScale,
                                height: 1.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textTertiary,
                                  size: 22,
                                ),
                                onPressed: () => setState(
                                  () => _isPasswordVisible = !_isPasswordVisible,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (_passwordError != null) ...[
                        SizedBox(height: screenHeight * 0.006),
                        Text(
                          _passwordError!,
                          style: TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 14 * textScale,
                          ),
                        ),
                      ],

                      SizedBox(height: screenHeight * 0.02),

                      // Terms
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (val) =>
                                setState(() => _agreeToTerms = val ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: AppColors.accentTeal,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: loc.termsText,
                                style: TextStyle(
                                  fontSize: 15 * textScale,
                                  color: AppColors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: loc.termsPolicy,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentTeal,
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
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            loc.termsError,
                            style: TextStyle(
                              color: AppColors.errorRed,
                              fontSize: 14 * textScale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.03),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: fieldHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  loc.signupButton,
                                  style: TextStyle(
                                    fontSize: 16 * textScale,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Signup with phone button
                      SizedBox(
                        width: double.infinity,
                        height: fieldHeight,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => userSignUpScreen(
                                  role: widget.role,
                                  locale: widget.locale,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Text(
                            loc.signupWithEmail,
                            style: TextStyle(
                              fontSize: 16 * textScale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black87,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Already have account
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LoginScreen(locale: widget.locale),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: loc.loginPromptExisting,
                              style: TextStyle(
                                fontSize: 17 * textScale,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textHint,
                              ),
                              children: [
                                TextSpan(
                                  text: loc.loginLink,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
