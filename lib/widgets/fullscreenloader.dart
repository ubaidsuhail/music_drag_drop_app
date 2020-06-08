import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black87,
        backgroundBlendMode: BlendMode.darken,
      ),
      child: Center(
        child: HeartbeatProgressIndicator(
            child: SizedBox(
          height: 60.0,
          width: 60.0,
          child: Image(image: AssetImage('assets/logo.png')),
        )),
      ),
    );
  }
}
