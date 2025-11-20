import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import 'login_with_email.dart';
import '../forget_pasword/forget_password.dart';
import '../../before_login_signup/choose_yourself.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final Locale locale;
  const LoginScreen({super.key, required this.locale});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _phoneError;
  String? _passwordError;

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

  void _validateAndLogin(AppLocalizations locale) {
    setState(() {
      _phoneError = null;
      _passwordError = null;
    });

    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    bool hasError = false;

    if (phone.isEmpty) {
      _phoneError = locale.phoneErrorEmpty;
      hasError = true;
    } else if (phone.length < 10 || phone.length > 13) {
      _phoneError = locale.phoneErrorInvalid;
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = locale.passwordErrorEmpty;
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = locale.passwordErrorShort;
      hasError = true;
    }

    if (!hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale.loginSuccess),
          backgroundColor: AppColors.snackbarDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double h(double value) => screenHeight * value;
    double w(double value) => screenWidth * value;
    double f(double value) => screenWidth * value / 375;

    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final locale = AppLocalizations.of(context)!;

          return Scaffold(
            backgroundColor: AppColors.backgroundWhite,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w(0.053),
                  vertical: h(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h(0.02)),

                    Center(
                      child: Text(
                        locale.login,
                        style: TextStyle(
                          fontSize: f(38),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    SizedBox(height: h(0.01)),

                    Center(
                      child: Text(
                        locale.loginDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: f(19),
                          color: AppColors.textBlack54,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: h(0.05)),

                    Text(
                      locale.phoneLabel,
                      style: TextStyle(
                        fontSize: f(19),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: h(0.008)),

                    Container(
                      height: h(0.065),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _phoneError == null
                              ? AppColors.borderLight
                              : AppColors.errorRed,
                          width: 1.3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: w(0.03)),
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
                                  "${_selectedCountry.countryCode} ",
                                  style: TextStyle(
                                    fontSize: f(16),
                                    color: AppColors.textBlack87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "+${_selectedCountry.phoneCode}",
                                  style: TextStyle(
                                    fontSize: f(16),
                                    color: AppColors.textBlack54,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textBlack54,
                                  size: f(22),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: w(0.02)),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    "+${_selectedCountry.phoneCode} XXX XX XX XXX",
                                hintStyle: TextStyle(
                                  color: AppColors.hintVeryLight,
                                  fontSize: f(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_phoneError != null)
                      Padding(
                        padding: EdgeInsets.only(top: h(0.005), left: w(0.01)),
                        child: Text(
                          _phoneError!,
                          style: TextStyle(
                            color: AppColors.errorRed,
                            fontSize: f(13),
                          ),
                        ),
                      ),

                    SizedBox(height: h(0.025)),

                    Text(
                      locale.passwordLabel,
                      style: TextStyle(
                        fontSize: f(19),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: h(0.006)),

                    Container(
                      height: h(0.065),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _passwordError == null
                              ? AppColors.borderLight
                              : AppColors.errorRed,
                          width: 1.3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: w(0.03)),
                      child: Center(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            height: 1.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: locale.passwordHint,
                            hintStyle: TextStyle(
                              color: AppColors.textBlack38,
                              fontSize: f(15),
                              height: 1.0,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textBlack38,
                                size: f(22),
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
                    ),
                    if (_passwordError != null)
                      Padding(
                        padding: EdgeInsets.only(top: h(0.005), left: w(0.01)),
                        child: Text(
                          _passwordError!,
                          style: TextStyle(
                            color: AppColors.errorRed,
                            fontSize: f(13),
                          ),
                        ),
                      ),

                    SizedBox(height: h(0.008)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ForgotPasswordScreen(locale: widget.locale),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(w(0.12), h(0.03)),
                        ),
                        child: Text(
                          locale.forgotPassword,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: f(15),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h(0.015)),

                    SizedBox(
                      width: double.infinity,
                      height: h(0.065),
                      child: ElevatedButton(
                        onPressed: () => _validateAndLogin(locale),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          locale.login,
                          style: TextStyle(
                            fontSize: f(20),
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h(0.02)),

                    SizedBox(
                      width: double.infinity,
                      height: h(0.065),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreenwithEmail(locale: widget.locale),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          locale.loginWithEmail,
                          style: TextStyle(
                            fontSize: f(18),
                            color: AppColors.textBlack87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h(0.25)),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: locale.loginPromptExisting,
                          style: TextStyle(
                            fontSize: f(15),
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
                                    fontSize: f(19),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
