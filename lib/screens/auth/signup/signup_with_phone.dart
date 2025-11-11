import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../otp/otp_signup.dart';
import '../login/login_screen.dart';
import 'signup_with_email.dart';

class userSignUpScreen extends StatefulWidget {
  final String role; // ✅ Accept role from previous screen
  const userSignUpScreen({super.key, required this.role});

  @override
  State<userSignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<userSignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;

  String? _phoneError;
  String? _passwordError;
  bool _showTermsError = false;

  Country _selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: '3001234567',
    displayName: 'Pakistan',
    displayNameNoCountryCode: 'Pakistan',
    e164Key: '',
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 📏 Responsive scaling
    final textScale = (screenWidth / 390).clamp(0.85, 1.15);
    final fieldHeight = screenHeight * 0.065;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
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

                  // 🔤 Title
                  Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 38 * textScale,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 🧾 Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    child: Text(
                      "To register your account, please fill the below\nfields to access the full features of this app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19 * textScale,
                        color: Colors.black54,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // 📱 Phone Label
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 18 * textScale,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // 📞 Phone Field
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: fieldHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _phoneError != null
                            ? Colors.redAccent
                            : Colors.black26,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() => _selectedCountry = country);
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "${_selectedCountry.flagEmoji} +${_selectedCountry.phoneCode}",
                                style: TextStyle(
                                  fontSize: 18 * textScale,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter your phone number",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 17 * textScale,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_phoneError != null) ...[
                    SizedBox(height: screenHeight * 0.006),
                    Text(
                      _phoneError!,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14 * textScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  SizedBox(height: screenHeight * 0.02),

                  // 🔐 Password Label
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 18 * textScale,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // 🔑 Password Field
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: fieldHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _passwordError != null
                            ? Colors.redAccent
                            : Colors.black26,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 18 * textScale,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black38,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  if (_passwordError != null) ...[
                    SizedBox(height: screenHeight * 0.006),
                    Text(
                      _passwordError!,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14 * textScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  SizedBox(height: screenHeight * 0.02),

                  // ✅ Terms Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (val) =>
                            setState(() => _agreeToTerms = val ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: const Color(0xFF00A8A8),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "I agree with ",
                            style: TextStyle(
                              fontSize: 15 * textScale,
                              color: Colors.black87,
                            ),
                            children: const [
                              TextSpan(
                                text: "Terms & Policy",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00A8A8),
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
                        "Please agree to Terms & Policy",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14 * textScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.03),

                  // 🚀 Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: fieldHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _phoneError = null;
                          _passwordError = null;
                          _showTermsError = false;
                        });

                        bool valid = true;

                        if (_phoneController.text.isEmpty) {
                          _phoneError = "Please enter phone number";
                          valid = false;
                        } else if (_phoneController.text.length < 7) {
                          _phoneError = "Enter a valid phone number";
                          valid = false;
                        }

                        if (_passwordController.text.isEmpty) {
                          _passwordError = "Please enter password";
                          valid = false;
                        } else if (_passwordController.text.length < 6) {
                          _passwordError =
                              "Password must be at least 6 characters";
                          valid = false;
                        }

                        if (!_agreeToTerms) {
                          _showTermsError = true;
                          valid = false;
                        }

                        setState(() {});

                        if (valid) {
                          final phone =
                              "+${_selectedCountry.phoneCode} ${_phoneController.text.trim()}";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserOtpVerificationScreen(
                                email: "",
                                phoneNumber: phone,
                                role: widget.role,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A8A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 16 * textScale,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 📧 Email Signup Button
                  SizedBox(
                    width: double.infinity,
                    height: fieldHeight,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserSignUpScreenEmail(role: widget.role),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(
                        "Sign up with Email",
                        style: TextStyle(
                          fontSize: 16 * textScale,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // 🔁 Login Text
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            fontSize: 17 * textScale,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                          children: const [
                            TextSpan(
                              text: "Log in",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00A8A8),
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
      ),
    );
  }
}
