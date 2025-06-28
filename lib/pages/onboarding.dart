import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';
import 'package:recycle_app/pages/login_screen.dart';  // Update import path
import 'package:recycle_app/pages/signup_screen.dart'; // Update import path

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Image.asset("images/onboard.png"),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Recycle your waste Products!!",
                style: AppWidget.headlinetextstyle(28.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Easily collect household waste",
                style: AppWidget.normaltextstyle(25),
              ),
            ),
            const Spacer(),
            // Login Button
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), // Updated widget name
              ),
              child: Material(
                elevation: 20.0,
                shadowColor: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: AppWidget.whitetextstyle(30.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Sign Up Button
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              ),
              child: Material(
                elevation: 20.0,
                shadowColor: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}