import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'sucessfully_verified.dart';

class UserOtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? phoneNumber;
  final String role;
  final Locale locale; // ✅ Added locale

  const UserOtpVerificationScreen({
    super.key,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.locale, // ✅ Require locale
  });

  @override
  State<UserOtpVerificationScreen> createState() =>
      _UserOtpVerificationScreenState();
}

class _UserOtpVerificationScreenState extends State<UserOtpVerificationScreen>
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

  Future<void> _verifyOtp() async {
    final local = AppLocalizations.of(context)!;

    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(local.invalidOtpMessage)));
      return;
    }

    setState(() => _isLoading = true);

    const String apiUrl =
        "https://stalagmitical-millie-unhomiletic.ngrok-free.dev/email-verify";

    final Map<String, dynamic> requestData = {
      "token": _otpController.text.trim(),
      "role": widget.role,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      setState(() => _isLoading = false);

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        debugPrint("⚠️ JSON decode error: $e");
        responseData = {"message": response.body};
      }

      final String? userId = responseData['user_id']?.toString();
      String message =
          responseData['message'] ??
          responseData['error'] ??
          "Something went wrong!";

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

      if (response.statusCode == 200 && userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserVerifiedScreen(
              contactValue: widget.email,
              isPhone: widget.phoneNumber != null,
              userId: userId,
              role: widget.role,
              locale: widget.locale, // ✅ Pass locale forward if needed
            ),
          ),
        );
      } else if (response.statusCode == 200 && userId == null) {
        debugPrint("⚠️ userId missing in backend response!");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.networkError}$e",
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
    return Localizations.override(
      context: context,
      locale: widget.locale, // ✅ Use passed locale
      child: Builder(
        builder: (context) {
          final local = AppLocalizations.of(context)!;
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

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
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
                        local.enterOtpTitle,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hasPhone
                            ? local.otpSentMessagePhone(contactValue)
                            : local.otpSentMessageEmail(contactValue),
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
                                  local.resendCode,
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
                                    local.didNotGetCode,
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
                          onPressed: _isLoading ? null : _verifyOtp,
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
                                  local.submit,
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
                            hasPhone
                                ? local.editPhoneNumber
                                : local.editEmailAddress,
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
            ),
          );
        },
      ),
    );
  }
}
