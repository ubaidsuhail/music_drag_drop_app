import 'dart:async';
import 'package:flutter/material.dart';
import '../global.dart';
import 'login.dart';
import 'package:music_application/sharedpreference/sharedpreferenceapp.dart';
import 'package:music_application/Screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String username;
  SharedPreferenceApp shPrefApp = SharedPreferenceApp();
  @override
  void initState() {
    super.initState();
      MoveToNextScreen();
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

  void MoveToNextScreen() async
  {

    username = await shPrefApp.GetUserName();

    if(username == null || username == "1")
      {
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

      else
        {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()));
        }


  }


}
