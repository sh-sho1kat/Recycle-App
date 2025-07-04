import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_app/admin/admin_approval_page.dart';
import 'package:recycle_app/admin/admin_dashboard.dart';
import 'package:recycle_app/pages/home.dart';
import 'package:recycle_app/pages/login.dart';
import 'package:recycle_app/pages/onboarding.dart';

void main()async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   // Replace with actual values
  //   options: FirebaseOptions(
  //     apiKey: "AIzaSyAGgZoMOzSg6TYPi2amKW6SXwaIuIcTduE",
  //     appId: "1:176790188634:android:1cfd8cfc287fd69c455e63",
  //     messagingSenderId: "176790188634",
  //     projectId: "recycleapp-b5179",
  //   ),
  // );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recycle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AdminDashboard(),  // Make sure Home is const if possible
    );
  }
}
