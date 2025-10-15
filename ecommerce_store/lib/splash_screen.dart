import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;

        Navigator.pushReplacementNamed(
          context,
          user != null ? '/navigationMenu' : '/login',
        );
      }
    });
  }

  // Timer? _timer; // Declare the timer as a class variable

  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer(Duration(seconds: 2), () {
  //     if (mounted) {
  //       // Check if the widget is still mounted
  //       final user = ref.read(userProvider);
  //       Navigator.pushReplacementNamed(
  //         context,
  //         user != null ? '/navigationMenu' : '/login',

  //         // MaterialPageRoute(
  //         //   builder: (context) =>
  //         //       user != null ? NavigationMenu() : OnboardingScreen(),
  //         // ),
  //       );
  //     }
  //   });
  // }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 42,
              child: Image.asset(
                'assets/bag.png',
                height: 42,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "E-Commerce App",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
