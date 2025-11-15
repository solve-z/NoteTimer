import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // TODO: Check if user is logged in
    // For now, always redirect to login page
    final isLoggedIn = await _isUserLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      context.goNamed('main');
    } else {
      context.goNamed('login');
    }
  }

  Future<bool> _isUserLoggedIn() async {
    // TODO: Implement actual login check logic
    // Check shared preferences, secure storage, or Hive
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            const Text(
              'NOTE TIMER',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB8860B),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
            ),
          ],
        ),
      ),
    );
  }
}
