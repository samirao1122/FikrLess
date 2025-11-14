import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../otp/otp_signup.dart';
import '../login/login_screen.dart';
import 'signup_with_email.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Localization import

class userSignUpScreen extends StatefulWidget {
  final String role;
  final Locale locale; // ✅ Add locale to keep language consistent
  const userSignUpScreen({super.key, required this.role, required this.locale});

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
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.white,
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
                            loc.signupTitle,
                            style: TextStyle(
                              fontSize: 38 * textScale,
                              fontWeight: FontWeight.w700,
                              color: AppColors.colorBlack,
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

                        // 📱 Phone Label
                        Text(
                          loc.phoneLabel,
                          style: TextStyle(
                            fontSize: 18 * textScale,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorBlack,
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
                                  ? AppColors.errorRed
                                  : AppColors.borderLight,
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
                                      setState(
                                        () => _selectedCountry = country,
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "${_selectedCountry.flagEmoji} +${_selectedCountry.phoneCode}",
                                      style: TextStyle(
                                        fontSize: 18 * textScale,
                                        color: AppColors.colorBlack,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.textHint,
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
                                    hintText: loc.phoneHint,
                                    hintStyle: TextStyle(
                                      color: AppColors.textTertiary,
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
                              color: AppColors.errorRed,
                              fontSize: 14 * textScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        SizedBox(height: screenHeight * 0.02),

                        // 🔐 Password Label
                        Text(
                          loc.passwordLabel,
                          style: TextStyle(
                            fontSize: 18 * textScale,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorBlack,
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
                                  ? AppColors.errorRed
                                  : AppColors.borderLight,
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
                              hintText: loc.passwordHint,
                              hintStyle: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 18 * textScale,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textTertiary,
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
                              color: AppColors.errorRed,
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
                                _phoneError = loc.phoneErrorEmpty;
                                valid = false;
                              } else if (_phoneController.text.length < 7) {
                                _phoneError = loc.phoneErrorInvalid;
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

                              if (valid) {
                                final phone =
                                    "+${_selectedCountry.phoneCode} ${_phoneController.text.trim()}";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserOtpVerificationScreen(
                                          email: "",
                                          phoneNumber: phone,
                                          role: widget.role,
                                          locale: widget.locale,
                                        ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Text(
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

                        // 📧 Email Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: fieldHeight,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserSignUpScreenEmail(
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

                        // 🔁 Login Text
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
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
            ),
          );
        },
      ),
    );
  }
}
