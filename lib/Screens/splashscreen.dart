import 'dart:async';
import 'package:flutter/material.dart';
import '../global.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds:3),
          pageBuilder: (context, __, ___) => Login(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Hero(
            child: Image(
              height: 250,
              width: MediaQuery.of(context).size.width * 2,
              image: AssetImage(
                SplashScreenConfig.logoAssetName,
              ),
            ),
            tag: 'logo',
          ),
        ),
      ),
    );
  }
}
