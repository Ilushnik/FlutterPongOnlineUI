import 'package:flutter_pong_online/app/modules/game_screen/game_screen_controller.dart';
import 'package:flutter/material.dart';

class ScoresWidget extends StatelessWidget {
  const ScoresWidget({Key? key, required this.controller}) : super(key: key);

  final GameScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${controller.gamelogic.topScore}',
          style: TextStyle(
              fontSize: controller.isBottom.value ? 15 : 25,
              fontWeight: FontWeight.bold),
        ),
        Text(
          'VS',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          '${controller.gamelogic.bottomScore}',
          style: TextStyle(
              fontSize: !controller.isBottom.value ? 15 : 25,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
