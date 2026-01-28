import 'package:arise_and_shine/constants/firebase_consts.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/screens/onbording/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  final profileController = Get.put(ProfileController());
  final authController = Get.put(AuthController());
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Simplified animations
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Remove rotation animation for smoother transition
    _backgroundColorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 255, 255, 255),
      end: const Color.fromARGB(255, 94, 164, 255),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    checkUser();
  }

  checkUser() async {
    auth.authStateChanges().listen((User? user) async {
      if (!hasNavigated) {
        hasNavigated = true;
        final isGuest = await authController.isGuestUser();

        Future.delayed(
          const Duration(milliseconds: 800),
          () {
            if (mounted) {
              Get.offAll(
                () => user == null
                    ? (isGuest ? const EntryPoint() : const OnboardingScreen())
                    : const EntryPoint(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 200),
              );
            }
          },
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,
          body: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    "assets/images/appbarlogo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
