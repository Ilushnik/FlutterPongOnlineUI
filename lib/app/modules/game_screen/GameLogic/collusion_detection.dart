import 'dart:math';

import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/utils.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/utils/screen_manager.dart';
import 'dart:developer' as dev;
import 'package:get/get.dart';

class CollusionDetection {
  final double playerPaddingY;
  final double playerHeight;
  final double playerWidth;
  final double ballDiameter;
  OnPlayerMadeAHit onPlayerMadeAHit;
  final GameSide gameSide;

  CollusionDetection(this.gameSide, this.playerPaddingY, this.playerHeight,
      this.playerWidth, this.ballDiameter, this.onPlayerMadeAHit);

  void checkCollusion(
      BallPosition ballPosition, double playerPositionX, playerPaddingY) {
    //don't check ball collusion with player if the ball higher of the bottm player and lower from top one
    if (ballPosition.ballPosY > 40 && ballPosition.ballPosY < 600) return;

    if (gameSide == GameSide.Bottom &&
        ballPosition.ballDirectionY == -1 &&
        _checkForCollusionForPlayer(
            ballPosition: ballPosition,
            gameSide: GameSide.Bottom,
            playerPositionX: playerPositionX)) {
      _calculateNewBallDirection(
          ballPosition: ballPosition,
          newDirectionY: 1,
          playerPositionX: playerPositionX);
    } else if (gameSide == GameSide.Top &&
        ballPosition.ballDirectionY == 1 &&
        _checkForCollusionForPlayer(
            ballPosition: ballPosition,
            gameSide: GameSide.Top,
            playerPositionX: playerPositionX)) {
      _calculateNewBallDirection(
          ballPosition: ballPosition,
          newDirectionY: -1,
          playerPositionX: playerPositionX);
    }
  }

  bool _checkForCollusionForPlayer(
      {required BallPosition ballPosition,
      required GameSide gameSide,
      required double playerPositionX}) {
    if (gameSide == GameSide.Bottom &&
        ballPosition.ballPosY < playerPaddingY + playerHeight &&
        ballPosition.ballPosX >= playerPositionX &&
        ballPosition.ballPosX <= playerPositionX + playerWidth) {
      dev.log('Bottom player made a hit');
      return true;
    } else if (gameSide == GameSide.Top &&
        ballPosition.ballPosY >
            ScreenManager.screenSizeHeight -
                playerPaddingY -
                playerHeight -
                ballDiameter &&
        ballPosition.ballPosX >= playerPositionX &&
        ballPosition.ballPosX <= playerPositionX + playerWidth) {
      dev.log('Top player made a hit');
      return true;
    }
    return false;
  }

  void _calculateNewBallDirection(
      {required BallPosition ballPosition,
      required int newDirectionY,
      required double playerPositionX}) {
    dev.log('_calculateNewBallDirection');
    var newDirectionX = 0;
    if (ballPosition.ballPosX < playerPositionX + playerWidth / 2) {
      newDirectionX = -1;
    } else {
      newDirectionX = 1;
    }

    var newballXSpeed = (playerPositionX +
            (playerWidth / 2) -
            (ballPosition.ballPosX + (ballDiameter / 2).abs()))
        .abs();
    if (newballXSpeed < 5) {
      newDirectionX = <int>[-1, 1][Random().nextInt(1)];
      newballXSpeed = (Random().nextDouble() * 10);
    }

    newballXSpeed = newballXSpeed * 100;

    onPlayerMadeAHit(
        currentBallPosition: ballPosition,
        newBallXSpeed: newballXSpeed.toPrecision(2),
        newDirectionX: newDirectionX,
        newDirectionY: newDirectionY);
  }
}
