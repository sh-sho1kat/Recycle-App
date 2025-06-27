import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';

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
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Image.asset("images/onboard.png"),
            SizedBox(height: 50.0),
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
            SizedBox(height: 120.0),
            Material(
              elevation: 20.0, // Increased elevation from 5.0 to 10.0
              shadowColor: Colors.green.withOpacity(0.5), // Added shadow color
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
                    "Get Started",
                    style: AppWidget.whitetextstyle(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}