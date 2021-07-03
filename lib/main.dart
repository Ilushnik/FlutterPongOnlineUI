import 'package:flutter_pong_online/app/utils/screen_manager.dart';
import 'package:flutter_pong_online/app/utils/signalr_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenManager.restrictWindow();
  await Get.put(SignalrConnection()).startConnection();

  runApp(
    GetMaterialApp(
      title: 'Application',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      enableLog: true,
      debugShowCheckedModeBanner: false,
    ),
  );
}
