import 'dart:ui';

import 'package:flutter/material.dart';

abstract class AppColors {
  // static const SlightlightBlue = Color(0xffE0F9FD);
  // static const SlightlightBlue = Color(0xff2A2E43);

}

abstract class AppImages {
  static const AssetImage background = AssetImage('assets/background.png');
  static const AssetImage videoIcon = AssetImage('assets/video_icon.png');

}

abstract class SplashScreenConfig {
  static const String logoAssetName = 'assets/logo.png';
  static const Color backgroundColor = Colors.white;
}

abstract class AppPadding {
  static const List<double> formFieldPadding = [40, 60];
}
