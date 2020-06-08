import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_application/theme.dart';

import 'Screens/SplashScreen.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}