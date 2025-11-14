import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../before_login_signup/choose_yourself.dart';
import '../forget_pasword/forget_password.dart';
import 'login_screen.dart';
import '../../userflow/user_dashboard.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

class LoginScreenwithEmail extends StatefulWidget {
  final Locale locale;
  const LoginScreenwithEmail({super.key, required this.locale});

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

  bool _validateInput(AppLocalizations locale) {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    bool hasError = false;

    if (email.isEmpty) {
      _emailError = locale.emailHint;
      hasError = true;
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = locale.emailHint;
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = locale.passwordErrorEmpty;
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = locale.passwordErrorShort;
      hasError = true;
    }

    return !hasError;
  }

  Future<void> _login(AppLocalizations locale) async {
    if (!_validateInput(locale)) return;

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
              responseData['message'] ?? locale.loginSuccess,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.snackbarDark,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserScreen(locale: widget.locale),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['error'] ?? locale.loginFailed,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.snackbarError,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.borderGrey, width: 1.5),
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
            "${locale.networkError} $e",
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.snackbarError,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.borderGrey, width: 1.5),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final locale = AppLocalizations.of(context)!;
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;

          double getResponsiveHeight(double value) => screenHeight * value;
          double getResponsiveWidth(double value) => screenWidth * value;
          double getResponsiveFont(double value) => screenWidth * value / 375;

          return Scaffold(
            backgroundColor: AppColors.backgroundWhite,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
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
                                  locale.login,
                                  style: TextStyle(
                                    fontSize: getResponsiveFont(38),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                              ),
                              SizedBox(height: getResponsiveHeight(0.01)),
                              Center(
                                child: Text(
                                  locale.loginDescription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getResponsiveFont(19),
                                    color: AppColors.textBlack54,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: getResponsiveHeight(0.05)),

                              /// ----- Email -----
                              Text(
                                locale.emailHint,
                                style: TextStyle(
                                  fontSize: getResponsiveFont(19),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              SizedBox(height: getResponsiveHeight(0.008)),
                              Container(
                                height: getResponsiveHeight(0.065),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _emailError == null
                                        ? AppColors.borderLight
                                        : AppColors.errorRed,
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
                                    hintText: locale.emailHint,
                                    hintStyle: TextStyle(
                                      color: AppColors.hintVeryLight,
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
                                      color: AppColors.errorRed,
                                      fontSize: getResponsiveFont(13),
                                    ),
                                  ),
                                ),

                              SizedBox(height: getResponsiveHeight(0.025)),

                              /// ----- Password -----
                              Text(
                                locale.passwordLabel,
                                style: TextStyle(
                                  fontSize: getResponsiveFont(19),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              SizedBox(height: getResponsiveHeight(0.006)),
                              Container(
                                height: getResponsiveHeight(0.065),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _passwordError == null
                                        ? AppColors.borderLight
                                        : AppColors.errorRed,
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
                                    hintText: locale.passwordHint,
                                    hintStyle: TextStyle(
                                      color: AppColors.textBlack38,
                                      fontSize: getResponsiveFont(15),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColors.textBlack38,
                                        size: getResponsiveFont(22),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
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
                                      color: AppColors.errorRed,
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
                                        builder: (context) =>
                                            ForgotPasswordScreen(
                                              locale: widget.locale,
                                            ),
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
                                    locale.forgotPassword,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: getResponsiveFont(15),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: getResponsiveHeight(0.015)),

                              /// Login Button
                              SizedBox(
                                width: double.infinity,
                                height: getResponsiveHeight(0.065),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => _login(locale),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: AppColors.white,
                                        )
                                      : Text(
                                          locale.login,
                                          style: TextStyle(
                                            fontSize: getResponsiveFont(20),
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: getResponsiveHeight(0.02)),

                              /// Login With Phone
                              SizedBox(
                                width: double.infinity,
                                height: getResponsiveHeight(0.065),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreen(locale: widget.locale),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.borderLight,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    locale.loginWithPhone,
                                    style: TextStyle(
                                      fontSize: getResponsiveFont(18),
                                      color: AppColors.textBlack87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: getResponsiveHeight(0.25)),

                              /// Sign Up
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: locale.loginPromptExisting,
                                    style: TextStyle(
                                      fontSize: getResponsiveFont(15),
                                      color: AppColors.textBlack87,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseWhoAreYouScreen(
                                                      locale: widget.locale,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            locale.signupLink,
                                            style: TextStyle(
                                              color: AppColors.primary,
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

                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
