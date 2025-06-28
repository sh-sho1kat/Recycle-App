import 'package:flutter/material.dart';
import 'package:recycle_app/pages/login_screen.dart';
import 'package:recycle_app/pages/signup_screen.dart';
import 'package:recycle_app/services/widget_support.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60.0),
            Center(
              child: Image.asset(
                "images/login.png",
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              "images/recycle1.png",
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Reduce. Reuse. Recycle.",
              style: AppWidget.headlinetextstyle(25.0),
            ),
            Text(
              "Repeat!",
              style: AppWidget.greentextstyle(32.0),
            ),
            const SizedBox(height: 40.0),
            Text(
              "Every item you recycle\nmakes a difference!",
              textAlign: TextAlign.center,
              style: AppWidget.normaltextstyle(18.0),
            ),
            const SizedBox(height: 50.0),
            // Login Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    // Navigate to Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: AppWidget.whitetextstyle(20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Sign Up Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    // Navigate to SignUp Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}