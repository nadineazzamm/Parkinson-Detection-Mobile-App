import 'package:flutter/material.dart';
import 'view/pages//sign_in_page.dart';
import 'view/pages//register_page.dart';
import 'view/pages/homepage.dart';
import 'view/pages//forgot_password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parkinsons Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Set initial route to sign in page
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignInPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}