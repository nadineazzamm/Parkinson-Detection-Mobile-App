// lib/view/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isAuthenticated = await AuthService().isAuthenticated();

    // Navigate to appropriate screen
    Navigator.pushReplacementNamed(
      context,
      isAuthenticated ? '/home' : '/signin',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}