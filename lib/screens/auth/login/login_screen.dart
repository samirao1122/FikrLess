import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import 'login_with_email.dart';
import '../forget_pasword/forget_password.dart';
import '../../before_login_signup/choose_yourself.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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

  void _validateAndLogin() {
    setState(() {
      _phoneError = null;
      _passwordError = null;
    });

    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    bool hasError = false;

    if (phone.isEmpty) {
      _phoneError = "Please enter your phone number";
      hasError = true;
    } else if (phone.length < 10 || phone.length > 13) {
      _phoneError = "Please enter a valid phone number";
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = "Please enter your password";
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      hasError = true;
    }

    if (!hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful ✅")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double h(double value) => screenHeight * value;
    double w(double value) => screenWidth * value;
    double f(double value) => screenWidth * value / 375; // 375 is base width

    return Scaffold(
      backgroundColor: Colors.white,
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
                  "Log in",
                  style: TextStyle(
                    fontSize: f(38),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: h(0.01)),

              Center(
                child: Text(
                  "To log in to your account please fill the below fields.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: f(19),
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: h(0.05)),

              // Phone Label
              Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: f(19),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: h(0.008)),

              // Phone Field
              Container(
                height: h(0.065),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _phoneError == null ? Colors.black26 : Colors.red,
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
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "+${_selectedCountry.phoneCode}",
                            style: TextStyle(
                              fontSize: f(16),
                              color: Colors.black54,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
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
                          hintText: "+92 XXX XX XX XXX",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(75, 0, 0, 0),
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
                    style: TextStyle(color: Colors.red, fontSize: f(13)),
                  ),
                ),

              SizedBox(height: h(0.025)),

              // Password Label
              Text(
                "Password",
                style: TextStyle(
                  fontSize: f(19),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: h(0.006)),

              // Password Field
              Container(
                height: h(0.065),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _passwordError == null ? Colors.black26 : Colors.red,
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: w(0.03)),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: f(15),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black38,
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
              if (_passwordError != null)
                Padding(
                  padding: EdgeInsets.only(top: h(0.005), left: w(0.01)),
                  child: Text(
                    _passwordError!,
                    style: TextStyle(color: Colors.red, fontSize: f(13)),
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
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(w(0.12), h(0.03)),
                  ),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: const Color(0xFF00A8A8),
                      fontWeight: FontWeight.w600,
                      fontSize: f(15),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(0.015)),

              // Log in Button
              SizedBox(
                width: double.infinity,
                height: h(0.065),
                child: ElevatedButton(
                  onPressed: _validateAndLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: f(20),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(0.02)),

              // Log in with Email
              SizedBox(
                width: double.infinity,
                height: h(0.065),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreenwithEmail(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    "Log in with Email",
                    style: TextStyle(
                      fontSize: f(18),
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(0.25)),

              // Sign up Link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(fontSize: f(15), color: Colors.black87),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseWhoAreYouScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: const Color(0xFF00A8A8),
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
  }
}
