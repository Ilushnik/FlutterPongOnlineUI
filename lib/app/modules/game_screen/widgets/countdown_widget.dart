import 'package:flutter_pong_online/app/modules/game_screen/game_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountDownWidget extends StatelessWidget {
  const CountDownWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GameScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(controller.counddownText.value),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              controller.counddownText.value,
              key: ValueKey(controller.counddownText.value),
            ),
          ),
        ));
  }
}
