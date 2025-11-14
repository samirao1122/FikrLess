import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import '../forget_pasword/pasword_reset_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Import your localization

class OtpForPaswordReset extends StatefulWidget {
  final String email;
  final String? phoneNumber;
  final Locale locale; // ✅ HIGHLIGHT: store the passed locale

  const OtpForPaswordReset({
    super.key,
    required this.email,
    required this.locale, // ✅ HIGHLIGHT: required locale
    this.phoneNumber,
  });

  @override
  State<OtpForPaswordReset> createState() => _OtpForPaswordResetState();
}

class _OtpForPaswordResetState extends State<OtpForPaswordReset>
    with SingleTickerProviderStateMixin {
  int _secondsRemaining = 59;
  Timer? _timer;
  bool _showResend = false;
  bool _isLoading = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _showResend = false;
      _secondsRemaining = 59;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _showResend = true);
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp(AppLocalizations loc) async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.invalidOtpMessage)));
      return;
    }

    setState(() => _isLoading = true);

    const String apiUrl =
        "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/email-verify";

    final Map<String, dynamic> requestData = {
      "token": _otpController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      setState(() => _isLoading = false);

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        debugPrint("⚠️ JSON decode error: $e");
        responseData = {"message": response.body};
      }

      final String? userId = responseData['user_id']?.toString();
      final String? backendToken = responseData['token']?.toString();

      String message =
          responseData['message'] ??
          responseData['error'] ??
          loc.networkError + "Something went wrong!";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: response.statusCode == 200
              ? AppColors.successGreen
              : AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

      if (response.statusCode == 200 &&
          userId != null &&
          backendToken != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              contactValue: widget.email,
              isPhone: false,
              userId: userId,
              token: backendToken,
              locale: widget.locale, // ✅ HIGHLIGHT: pass locale to next screen
            ),
          ),
        );
      } else {
        debugPrint("⚠️ Missing userId or token in backend response");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.networkError + e.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ HIGHLIGHT: Override localization using passed locale
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!; // ✅ localized strings

          final bool hasPhone =
              widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty;
          final String contactValue = hasPhone
              ? widget.phoneNumber!
              : widget.email;

          final defaultPinTheme = PinTheme(
            width: 75,
            height: 75,
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.colorShadow),
              borderRadius: BorderRadius.circular(12),
            ),
          );

          return Scaffold(
            backgroundColor: AppColors.backgroundWhite,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      loc.enterOtpTitle,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hasPhone
                          ? loc.otpSentMessagePhone(contactValue)
                          : loc.otpSentMessageEmail(contactValue),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textBlack54,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Pinput(
                      length: 4,
                      controller: _otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(
                            color: AppColors.accentTeal,
                            width: 2,
                          ),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: AppColors.accentTeal),
                        ),
                      ),
                      showCursor: true,
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _showResend
                          ? GestureDetector(
                              key: const ValueKey('resend'),
                              onTap: _startTimer,
                              child: Text(
                                loc.resendCode,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.accentTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Row(
                              key: const ValueKey('timer'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  loc.didNotGetCode,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                Text(
                                  "00:${_secondsRemaining.toString().padLeft(2, '0')}s",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.accentTeal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _verifyOtp(loc),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                loc.submit,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          hasPhone ? loc.editPhoneNumber : loc.editEmailAddress,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack87,
                          ),
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
    );
  }
}
