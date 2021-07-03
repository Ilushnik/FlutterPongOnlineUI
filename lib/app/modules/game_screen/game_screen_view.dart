import 'dart:ui';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/countdown_widget.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/waiting_for_other_player_widget.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/score_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_screen_controller.dart';

class GameScreenView extends GetView<GameScreenController> {
  final List<Color> backgroundColors = [Colors.blue[200]!, Colors.red[200]!];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: controller.isBottom.isTrue
                        ? backgroundColors.reversed.toList()
                        : backgroundColors,
                  ),
                ),
              ),
            ),
            getDebugInfo(),
            Center(
              child: controller.obx(
                  (state) => ScoresWidget(controller: controller),
                  onEmpty: WaitingForOtherPlayer(),
                  onLoading: CountDownWidget(controller: controller)),
            ),
            Player(
              posX: controller.gamelogic.playerTopPosX.value,
              paddingY: controller.gamelogic.playerPaddingY.value,
              gameSide: GameSide.Top,
              width: controller.gamelogic.playerWidth.value,
              height: controller.gamelogic.playerHeight.value,
              onPosXChanged: (double newPosX) {
                controller.gamelogic.playerTopPosX.value = newPosX;
              },
              onPosXChanging: (double dX) {
                controller.gamelogic.playerTopPosX.value =
                    controller.gamelogic.playerTopPosX.value + dX;
              },
              playerSide:
                  controller.isBottom.isTrue ? GameSide.Bottom : GameSide.Top,
              playerUpdateInMiliseconds: controller.isBottom.isFalse
                  ? 0
                  : controller.gamelogic.playersSyncInMiliseconds,
            ),
            Player(
              posX: controller.gamelogic.playerBottomPosX.value,
              paddingY: controller.gamelogic.playerPaddingY.value,
              gameSide: GameSide.Bottom,
              width: controller.gamelogic.playerWidth.value,
              height: controller.gamelogic.playerHeight.value,
              onPosXChanged: (double newPosX) {
                controller.gamelogic.playerBottomPosX.value = newPosX;
              },
              onPosXChanging: (double delta) {
                controller.gamelogic.playerBottomPosX.value =
                    controller.gamelogic.playerBottomPosX.value + delta;
              },
              playerSide:
                  controller.isBottom.isTrue ? GameSide.Bottom : GameSide.Top,
              playerUpdateInMiliseconds: controller.isBottom.isTrue
                  ? 0
                  : controller.gamelogic.playersSyncInMiliseconds,
            ),
            Positioned(
              bottom: controller.gamelogic.ballLogic.posYTween == null
                  ? controller.gamelogic.ballLogic.ballPosY.value
                  : controller.gamelogic.ballLogic.posYTween!.value,
              left: controller.gamelogic.ballLogic.ballPosX.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                width: controller.gamelogic.ballLogic.ballDiameter,
                height: controller.gamelogic.ballLogic.ballDiameter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDebugInfo() {
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
/*
class InformationForPlayer extends StatelessWidget {
  const InformationForPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GameScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(controller.nonStartedText.value),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              controller.nonStartedText.value,
              key: ValueKey(controller.nonStartedText.value),
            ),
          ),
        ));
  }
}*/
