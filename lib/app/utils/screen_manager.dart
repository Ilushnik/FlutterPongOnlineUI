import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

class ScreenManager {
  static double screenTitleHeight = 20.0;
  static double screenSizeWidth = 1264.0;
  static double screenSizeHeight = 681.0;

  static Future<void> restrictWindow() async {
    await DesktopWindow.setMinWindowSize(
        Size(screenSizeWidth, screenSizeHeight + screenTitleHeight));
    await DesktopWindow.setMaxWindowSize(
        Size(screenSizeWidth, screenSizeHeight + screenTitleHeight));
  }
}
