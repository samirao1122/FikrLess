import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pinput/pinput.dart';
// import 'pasword_reset_screen.dart';
import 'package:http/http.dart' as http;

import '../forget_pasword/pasword_reset_screen.dart';

class OtpForPaswordReset extends StatefulWidget {
  final String email;
  final String? phoneNumber;

  const OtpForPaswordReset({super.key, required this.email, this.phoneNumber});

  @override
  State<OtpForPaswordReset> createState() => _UserOtpVerificationScreenState();
}

class _UserOtpVerificationScreenState extends State<OtpForPaswordReset>
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
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
      );
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

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        debugPrint("⚠️ JSON decode error: $e");
        responseData = {"message": response.body};
      }

      // ✅ Extract fields from backend response
      final String? userId = responseData['user_id']?.toString();
      final String? backendToken = responseData['token']
          ?.toString(); // 👈 new line

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
              ? Colors.green
              : Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

      // ✅ Success case: pass userId + token forward
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
              token: backendToken, // 👈 pass the token forward
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
            "Network error: $e",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhone =
        widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty;
    final String contactType = hasPhone ? 'phone number' : 'email';
    final String contactValue = hasPhone ? widget.phoneNumber! : widget.email;

    final defaultPinTheme = PinTheme(
      width: 75,
      height: 75,
      textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "We have sent you an OTP on your $contactType:\n$contactValue\nPlease check your ${hasPhone ? 'messages' : 'inbox'} and enter the OTP to verify.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
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
                      color: const Color(0xFF00A8A8),
                      width: 2,
                    ),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: const Color(0xFF00A8A8)),
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
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF00A8A8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Row(
                        key: const ValueKey('timer'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't get the code? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "00:${_secondsRemaining.toString().padLeft(2, '0')}s",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF00A8A8),
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
                    backgroundColor: const Color(0xFF00A8A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                    side: const BorderSide(color: Colors.black26, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    hasPhone ? "Edit Phone Number" : "Edit Email Address",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
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
