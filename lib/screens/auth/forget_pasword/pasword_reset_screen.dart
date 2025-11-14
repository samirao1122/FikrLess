import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_sucessfully.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Import AppLocalizations

class ResetPasswordScreen extends StatefulWidget {
  final String contactValue; // email or phone
  final bool isPhone;
  final String userId;
  final String token;
  final Locale locale; // ✅ HIGHLIGHT: accept locale

  const ResetPasswordScreen({
    super.key,
    required this.contactValue,
    required this.isPhone,
    required this.userId,
    required this.token,
    required this.locale, // ✅ HIGHLIGHT: pass locale
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
    setState(() => _isLoading = true);

    final String newPassword = _newPasswordController.text.trim();

    final Uri url = Uri.parse(
      "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/change-password",
    );

    final Map<String, dynamic> requestData = {
      "new_password": newPassword,
      "token": widget.token,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);

      final loc = AppLocalizations.of(
        context,
      )!; // ✅ HIGHLIGHT: localized strings

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? loc.passwordResetSuccessMessage,
              style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetSuccessfully(
              locale: widget.locale, // ✅ HIGHLIGHT: pass locale to next screen
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "Failed to change password!",
              style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${loc.networkError} $e",
            style: TextStyle(fontSize: _f(16), fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
    final local = AppLocalizations.of(context)!;

    if (newPassword.isEmpty) {
      _newPasswordError = local.newPasswordErrorEmpty;
      hasError = true;
    } else if (!_isStrongPassword(newPassword)) {
      _newPasswordError = local.newPasswordErrorWeak;
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = local.confirmPasswordErrorEmpty;
      hasError = true;
    } else if (confirmPassword != newPassword) {
      _confirmPasswordError = local.confirmPasswordErrorMismatch;
      hasError = true;
    }

    if (!hasError) {
      _changePassword();
    } else {
      setState(() {});
    }
  }

  // ⚡ Responsive helpers
  late double _screenHeight;
  late double _screenWidth;

  double _h(double value) => _screenHeight * value;
  double _w(double value) => _screenWidth * value;
  double _f(double value) => _screenWidth * value / 375;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;

    // ✅ HIGHLIGHT: Override localization using passed locale
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final local = AppLocalizations.of(context)!; // ✅ HIGHLIGHT

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _w(0.064)),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: _h(0.022)),
                        Text(
                          local.resetPasswordTitle,
                          style: TextStyle(
                            fontSize: _f(36),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkBlue,
                          ),
                        ),
                        SizedBox(height: _h(0.006)),
                        Text(
                          local.resetPasswordDescription(widget.contactValue),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: _f(17),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: _h(0.08)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            local.newPasswordLabel,
                            style: TextStyle(
                              color: AppColors.textGrey700,
                              fontWeight: FontWeight.w600,
                              fontSize: _f(14),
                            ),
                          ),
                        ),
                        SizedBox(height: _h(0.021)),
                        TextField(
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          decoration: InputDecoration(
                            hintText: local.enterNewPasswordHint,
                            filled: true,
                            fillColor: AppColors.backgroundGrey100,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.borderGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: _w(0.037),
                              vertical: _h(0.019),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_w(0.016)),
                              borderSide: const BorderSide(
                                color: AppColors.borderGrey300,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_w(0.016)),
                              borderSide: BorderSide(
                                color: _newPasswordError == null
                                    ? AppColors.borderGrey300
                                    : AppColors.errorPureRed,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                        if (_newPasswordError != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: _h(0.007),
                              left: _w(0.011),
                            ),
                            child: Text(
                              _newPasswordError!,
                              style: TextStyle(
                                color: AppColors.errorPureRed,
                                fontSize: _f(13),
                              ),
                            ),
                          ),
                        SizedBox(height: _h(0.053)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            local.confirmPasswordLabel,
                            style: TextStyle(
                              color: AppColors.textGrey700,
                              fontWeight: FontWeight.w600,
                              fontSize: _f(14),
                            ),
                          ),
                        ),
                        SizedBox(height: _h(0.011)),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            hintText: local.reEnterPasswordHint,
                            filled: true,
                            fillColor: AppColors.backgroundGrey100,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.borderGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: _w(0.037),
                              vertical: _h(0.019),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_w(0.016)),
                              borderSide: const BorderSide(
                                color: AppColors.borderGrey300,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_w(0.016)),
                              borderSide: BorderSide(
                                color: _confirmPasswordError == null
                                    ? AppColors.borderGrey300
                                    : AppColors.errorPureRed,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                        if (_confirmPasswordError != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: _h(0.007),
                              left: _w(0.011),
                            ),
                            child: Text(
                              _confirmPasswordError!,
                              style: TextStyle(
                                color: AppColors.errorPureRed,
                                fontSize: _f(13),
                              ),
                            ),
                          ),
                        SizedBox(height: _h(0.05)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _validateAndSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                vertical: _h(0.017),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_w(0.016)),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                : Text(
                                    local.submit,
                                    style: TextStyle(
                                      fontSize: _f(16),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: _h(0.106)),
                      ],
                    ),
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
