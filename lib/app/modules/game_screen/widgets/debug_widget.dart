import 'package:flutter_pong_online/app/modules/game_screen/game_screen_controller.dart';
import 'package:flutter/material.dart';

class DebugWidget extends StatelessWidget {
  final GameScreenController controller;
  const DebugWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 200,
        child: Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hor Speed: ${controller.gamelogic.ballLogic.ballXSpeed}'),
              Text('Ver Speed: ${controller.gamelogic.ballLogic.ballYSpeed}'),
              Text('PosX: ${controller.gamelogic.ballLogic.ballPosX}'),
              Text('PosY: ${controller.gamelogic.ballLogic.ballPosY}'),
              Text('DirectX: ${controller.gamelogic.ballLogic.directionX}'),
              Text('DirectY: ${controller.gamelogic.ballLogic.directionY}'),
              Text('PlayerTopPosX: ${controller.gamelogic.playerTopPosX}'),
              Text(
                  'PlayerBottomPosX: ${controller.gamelogic.playerBottomPosX}'),
            ],
          ),
        ));
  }
}
