// redeem_points_admin_page.dart

import 'package:flutter/material.dart';

class RedeemPointsPage extends StatefulWidget {
  const RedeemPointsPage({Key? key}) : super(key: key);

  @override
  State<RedeemPointsPage> createState() => _RedeemPointsPageState();
}

class _RedeemPointsPageState extends State<RedeemPointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Redemptions'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Redeem Points Management - To be implemented'),
      ),
    );
  }
}