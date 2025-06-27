import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "images/login.png",
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0),
            Image.asset(
              "images/recycle1.png",
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            Text(
              "Reduce. Reuse. Recycle.",
              style: AppWidget.headlinetextstyle(25.0),
            ),
            Text(
              "Repeat!",
              style: AppWidget.greentextstyle(32.0),
            ),
            SizedBox(height: 40.0),
            Text(
              "Every item you recycle\nmakes a difference!",
              textAlign: TextAlign.center,
              style: AppWidget.normaltextstyle(18.0),
            ),
            SizedBox(height: 20.0),
            Text(
              "Get Started!",
              style: AppWidget.greentextstyle(24.0),
            ),
            SizedBox(height: 30.0),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          "images/google.png",
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        "Sign in with Google",
                        style: AppWidget.whitetextstyle(20.0),
                      ),
                    ],
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