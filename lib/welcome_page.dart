import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kejaksaan/intro01_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void initState(){
    super.initState();
    splashscreenStart();
  }

  splashscreenStart() async{
    var duration = const Duration(seconds: 8);
    return Timer(duration, (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Intro01()),
      );
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Adjusted to a neutral color to accommodate the colorful welcome image
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Intro01()),

            );
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center, // This centers the content within the stack
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/splashscreen.png', // Make sure this path matches your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
