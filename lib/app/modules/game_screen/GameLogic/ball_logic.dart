import 'dart:async';

import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/utils.dart';
import 'package:flutter_pong_online/app/utils/screen_manager.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class BallLogic {
  final RxDouble ballPosX = 100.0.obs;
  final RxDouble ballPosY = 100.0.obs;

  int directionX = 1;
  int directionY = 1;

  final double ballradius = 10.0;
  late double ballDiameter;

  final RxDouble ballXSpeed = 0.0.obs;
  final RxDouble ballYSpeed = 0.0.obs;

  late AnimationController animationController;
  Animation<double>? posXTween;
  Animation<double>? posYTween;

  SingleGetTickerProviderMixin vsync;

  RxInt gameTickInSeconds = 10.obs;

  late Timer gameLoopTimer;

  late BallPositionFunc _onBallPositionChanged;

  late OnHitFunc _onHitFunc;

  BallLogic(
      {required onBallPositionChanged,
      required this.vsync,
      required onHitFunc}) {
    _onBallPositionChanged = onBallPositionChanged;
    _onHitFunc = onHitFunc;

    ballDiameter = ballradius * 2;

    gameLoopTimer = Timer.periodic(
        Duration(seconds: gameTickInSeconds.value), onUpdateTick);
    animationController =
        AnimationController(vsync: vsync, duration: Duration(seconds: 4))
          ..addListener(() {
            ballPosX.value = posXTween!.value;
            ballPosY.value = posYTween!.value;
          });
  }

  void onUpdateTick(Timer timer) {
    onUpdate();
  }

  void onUpdate() {
    var posXOld = ballPosX.value;
    var posYOld = ballPosY.value;

    animationController.stop();
    animationController.dispose();
    animationController =
        AnimationController(vsync: vsync, duration: Duration(seconds: 4))
          ..addListener(() {
            ballPosX.value = posXTween!.value.toPrecision(2);
            ballPosY.value = posYTween!.value.toPrecision(2);
            checkForObsticals();
          });

    posXTween = Tween<double>(
            begin: posXOld, end: ballPosX.value + ballXSpeed.value * directionX)
        .animate(animationController);

    posYTween = Tween<double>(
            begin: posYOld, end: ballPosY.value + ballYSpeed.value * directionY)
        .animate(animationController);
    animationController.forward();
  }

  void checkForObsticals() {
    if (ballPosX < 0 && directionX == -1) {
      directionX = 1;
      _onHitFunc(Side.Left);
      onUpdate();
    }

    if (ballPosX >= ScreenManager.screenSizeWidth - ballDiameter &&
        directionX == 1) {
      directionX = -1;
      _onHitFunc(Side.Right);
      onUpdate();
    }

    if (ballPosY >= ScreenManager.screenSizeHeight - ballDiameter &&
        directionY == 1) {
      directionY = -1;
      _onHitFunc(Side.Top);
      onUpdate();
    }

    if (ballPosY < 0 && directionY == -1) {
      directionY = 1;
      _onHitFunc(Side.Bottom);
      onUpdate();
    }

    _onBallPositionChanged(BallPosition(
        ballPosX: ballPosX.value,
        ballPosY: ballPosY.value,
        ballXSpeed: ballXSpeed.value,
        ballYSpeed: ballYSpeed.value,
        ballDirectionX: directionX,
        ballDirectionY: directionY));
  }

  void onHit(Side side) {
    print('onHit $side');
    switch (side) {
      case Side.Left:
        directionX = 1;
        break;
      case Side.Right:
        directionX = -1;
        break;
      case Side.Top:
        directionY = -1;
        break;
      case Side.Bottom:
        directionY = 1;
        break;
    }
    onUpdate();
  }

  void change(BallPosition ballPosition) {
    ballPosX.value = ballPosition.ballPosX;
    ballPosY.value = ballPosition.ballPosY;
    ballXSpeed.value = ballPosition.ballXSpeed;
    ballYSpeed.value = ballPosition.ballYSpeed;
    directionX = ballPosition.ballDirectionX;
    directionY = ballPosition.ballDirectionY;
    onUpdate();
  }

  void startGame() {
    print('Game Started');
    ballXSpeed.value = 3600.0;
    ballYSpeed.value = 3000.0;
    onUpdate();
  }

  void finishGame() {
    print('finishGame');
    gameLoopTimer.cancel();
    animationController.stop();
    animationController.dispose();
  }
}
