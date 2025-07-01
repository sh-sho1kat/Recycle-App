import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_app/admin/admin_dashboard.dart';
import 'package:recycle_app/admin/admin_login.dart';
import 'package:recycle_app/pages/home.dart';
import 'package:recycle_app/pages/login.dart';
import 'package:recycle_app/pages/login_screen.dart';
import 'package:recycle_app/pages/onboarding.dart';
import 'package:recycle_app/pages/upload_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AdminDashboard(),
    );
  }
}

