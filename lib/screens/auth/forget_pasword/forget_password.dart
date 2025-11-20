import 'dart:convert';
import 'package:fikr_less/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../otp/otp_reset_pasword.dart' show OtpForPaswordReset;

import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Import AppLocalizations

class ForgotPasswordScreen extends StatefulWidget {
  final Locale locale; // store the locale

  const ForgotPasswordScreen({super.key, required this.locale});

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
      '$baseUrl/auth/forgot-password',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text.trim()}),
      );

      final data = jsonDecode(response.body);
      final loc = AppLocalizations.of(context)!;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? loc.otpSent,
              style: TextStyle(fontSize: _f(14)),
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpForPaswordReset(
              email: _emailController.text.trim(),
              locale: widget.locale,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['error'] ?? loc.failedToSendOtp,
              style: TextStyle(fontSize: _f(14)),
            ),
            backgroundColor: AppColors.errorPureRed,
          ),
        );
      }
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${loc.networkError}$e',
            style: TextStyle(fontSize: _f(14)),
          ),
          backgroundColor: AppColors.errorPureRed,
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
  double _f(double value) => _screenWidth * value / 375;
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;

    return Localizations.override(
      context: context,
      locale: widget.locale, // ✅ apply the passed locale
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _w(0.064)),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: _h(0.04)),
                          Text(
                            loc.forgotPassword,
                            style: TextStyle(
                              fontSize: _f(36),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                          SizedBox(height: _h(0.016)),
                          Text(
                            loc.forgotDescription,
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
                              loc.emailHint,
                              style: TextStyle(
                                color: AppColors.textGrey700,
                                fontWeight: FontWeight.w600,
                                fontSize: _f(14),
                              ),
                            ),
                          ),
                          SizedBox(height: _h(0.021)),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: loc.emailHint,
                              filled: true,
                              fillColor: AppColors.backgroundGrey100,
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
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return loc.emailHint;
                              }
                              if (!_isValidEmail(value.trim())) {
                                return loc.validEmailError;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: _h(0.08)),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _submitForgotPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  vertical: _h(0.037),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    _w(0.016),
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: AppColors.white,
                                    )
                                  : Text(
                                      loc.submit,
                                      style: TextStyle(
                                        fontSize: _f(16),
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: _h(0.021)),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: _h(0.037),
                                ),
                                side: const BorderSide(
                                  color: AppColors.borderGrey300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    _w(0.016),
                                  ),
                                ),
                              ),
                              child: Text(
                                loc.back,
                                style: TextStyle(
                                  fontSize: _f(16),
                                  color: AppColors.black87,
                                  fontWeight: FontWeight.w500,
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
            ),
          );
        },
      ),
    );
  }
}
