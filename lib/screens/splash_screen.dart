import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'before_login_signup/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cloudAnim;
  late Animation<double> _fadeInAnim;
  late Animation<double> _logoFloatAnim;
  late Animation<double> _logoScaleAnim;

  @override
  void initState() {
    super.initState();

    // 🌫️ Ultra-smooth looping animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // ☁️ Soft horizontal/vertical cloud drift
    _cloudAnim = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // 🌟 Smooth fade-in for logo
    _fadeInAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.4, curve: Curves.easeInOut),
      ),
    );

    // 🫧 Gentle logo floating (breathing)
    _logoFloatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // 🔍 Soft logo zoom-in (adds depth)
    _logoScaleAnim = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // ⏳ Splash duration
    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BeforeLogin()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00A8A8), // 🌿 rich aqua
                  Color(0xFF9FEDE6), // 🌊 lighter mint
                  Color(0xFFB9F3EC), // 🌤 soft mint bottom
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // ☁️ Gentle drifting clouds
                Positioned(
                  top: -100 + _cloudAnim.value / 2,
                  left: -80,
                  child: _mistCloud(280, 220, 0.25),
                ),
                Positioned(
                  bottom: -40 - _cloudAnim.value / 3,
                  left: -60,
                  child: _mistCloud(320, 280, 0.18),
                ),
                Positioned(
                  top: -50 + _cloudAnim.value,
                  right: -100,
                  child: _mistCloud(380, 340, 0.30),
                ),
                Positioned(
                  top: 180 - _cloudAnim.value / 2,
                  right: -60,
                  child: _mistCloud(320, 280, 0.26),
                ),
                Positioned(
                  bottom: -100 + _cloudAnim.value / 1.5,
                  right: -70,
                  child: _mistCloud(400, 340, 0.28),
                ),
                Positioned(
                  bottom: 50 - _cloudAnim.value / 1.2,
                  right: 30,
                  child: _mistCloud(240, 200, 0.20),
                ),

                // 🌟 Center logo — fade, float, and zoom-in smoothly
                Center(
                  child: AnimatedOpacity(
                    opacity: _fadeInAnim.value,
                    duration: const Duration(seconds: 3),
                    child: Transform.translate(
                      offset: Offset(0, _logoFloatAnim.value),
                      child: Transform.scale(
                        scale: _logoScaleAnim.value,
                        child: Image.asset(
                          'assets/images/splash_screen/fikr_less_splash_image.png',
                          width: 340,
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ☁️ Ultra-soft translucent cloud blob
  static Widget _mistCloud(double w, double h, double opacity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(w * 0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(w * 0.7),
          ),
        ),
      ),
    );
  }
}
