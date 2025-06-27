import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/wave.png",
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Hello, ",
                      style: AppWidget.headlinetextstyle(26.0),
                    ),
                  ),
                  Text(
                    "Shoikat",
                    style: AppWidget.greentextstyle(26),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "images/boy.jpg",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset("images/home.png"),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Categories",
                  style: AppWidget.headlinetextstyle(24.0),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Plastic Category
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFeceff8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            "images/plastic.png",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Plastic",
                          style: AppWidget.normaltextstyle(20.0),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    // Paper Category
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFeceff8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            "images/paper.png",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Paper",
                          style: AppWidget.normaltextstyle(20.0),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    // Battery Category
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFeceff8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            "images/battery.png",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Battery",
                          style: AppWidget.normaltextstyle(20.0),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    // Glass Category
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFeceff8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            "images/glass.png",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Glass",
                          style: AppWidget.normaltextstyle(20.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Pending Request",
                  style: AppWidget.headlinetextstyle(24.0),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Rajshahi, Bangladesh",
                          style: AppWidget.normaltextstyle(20.0),
                        ),
                      ],
                    ),
                    Divider(),
                    Image.asset(
                      "images/chips.png",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.layers,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "3",
                          style: AppWidget.normaltextstyle(24.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}