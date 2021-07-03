import 'dart:async';
import 'dart:math';
import 'package:flutter_pong_online/app/data/player_position.dart';
import 'package:flutter_pong_online/app/data/game_position.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/ball_Logic.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/utils.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/utils/screen_manager.dart';
import 'package:get/get.dart';

class Gamelogic {
  final RxDouble playerBottomPosX = 0.0.obs;
  final RxDouble playerTopPosX = 0.0.obs;

  final RxDouble playerPaddingY = 20.0.obs;
  final RxDouble playerHeight = 10.0.obs;
  final RxDouble playerWidth = 120.0.obs;

  late GameSide gameside;
  late Function syncGamePosition;
  late Function syncPlayerPosition;

  late Timer playerPositionTimer;

  final bottomScore = 0.obs;
  final topScore = 0.obs;

  final int playersSyncInMiliseconds = 500;

  late BallLogic ballLogic;

  RxString scoreText = ''.obs;
  late var scoreFromServer = ''.obs;

  Gamelogic(
      {required this.gameside,
      required this.syncGamePosition,
      required this.syncPlayerPosition,
      required vsync}) {
    ballLogic = BallLogic(
        vsync: vsync,
        onBallPositionChanged: onBallPositionChanged,
        onHitFunc: onBallHitBound);
    playerPositionTimer = Timer.periodic(
        Duration(milliseconds: playersSyncInMiliseconds),
        (t) => _onSyncPlayerPosition());
  }

  void onBallHitBound(Side side) {
    if (side == Side.Bottom) {
      topScore.value++;
      _updateGamePositionToServer();
    } else if (side == Side.Top) {
      bottomScore.value++;
      _updateGamePositionToServer();
    }
    ;
  }

  void onBallPositionChanged(BallPosition ballPosition) {
//test
    /*  if (ballPosition.ballPosY > 300) {
      ballLogic.onHit(Side.Top);
    }*/

    if (_isMaster &&
        ballPosition.ballDirectionY == -1 &&
        ballPosition.ballPosY < playerPaddingY.value + playerHeight.value &&
        ballPosition.ballPosX >= playerBottomPosX.value &&
        ballPosition.ballPosX <= playerBottomPosX.value + playerWidth.value) {
      print('Bottom player made a hit');
      var newDirectionX = 0;
      if (ballPosition.ballPosX < playerBottomPosX.value + playerWidth / 2) {
        newDirectionX = -1;
      } else {
        newDirectionX = 1;
      }

      var newballXSpeed = (playerBottomPosX.value +
              (playerWidth.value / 2) -
              (ballPosition.ballPosX + ballLogic.ballradius.abs()))
          .abs();
      if (ballPosition.ballXSpeed > 70) newballXSpeed = 70;

      var directionY = 1;

      newballXSpeed = newballXSpeed * 10;

      ballLogic.change(BallPosition(
          ballPosX: ballPosition.ballPosX,
          ballPosY: ballPosition.ballPosY,
          ballXSpeed: newballXSpeed,
          ballYSpeed: ballPosition.ballYSpeed,
          ballDirectionX: newDirectionX,
          ballDirectionY: directionY));

      _updateGamePositionToServer();
    }

    if (!_isMaster &&
        ballPosition.ballDirectionY == 1 &&
        ballPosition.ballPosY >
            ScreenManager.screenSizeHeight -
                playerPaddingY.value -
                playerHeight.value -
                ballLogic.ballDiameter &&
        ballPosition.ballPosX >= playerTopPosX.value &&
        ballPosition.ballPosX <= playerTopPosX.value + playerWidth.value) {
      print('Top player made a hit');
      var newDirectionX = 0;
      if (ballPosition.ballPosX < playerTopPosX.value + playerWidth / 2) {
        newDirectionX = -1;
      } else {
        newDirectionX = 1;
      }

      var newballXSpeed = (playerTopPosX.value +
              (playerWidth.value / 2) -
              (ballPosition.ballPosX + ballLogic.ballradius.abs()))
          .abs();
      if (ballPosition.ballXSpeed > 70) newballXSpeed = 70;
      if (ballPosition.ballXSpeed < 5) {
        newDirectionX = <int>[-1, 1][Random().nextInt(1)];
        newballXSpeed = (Random().nextDouble().toPrecision(2) * 10);
      }
      var directionY = -1;

      newballXSpeed = newballXSpeed * 10;

      ballLogic.change(BallPosition(
          ballPosX: ballPosition.ballPosX,
          ballPosY: ballPosition.ballPosY,
          ballXSpeed: newballXSpeed,
          ballYSpeed: ballPosition.ballYSpeed,
          ballDirectionX: newDirectionX,
          ballDirectionY: directionY));
      _updateGamePositionToServer();
    }
  }

  void startGame() {
    ballLogic.startGame();
    if (_isMaster) _updateGamePositionToServer();
  }

  void _updateGamePositionToServer() {
    print('_updateGamePositionToServer outgoing');
    syncGamePosition(GamePosition(
      ballPosX: ballLogic.ballPosX.value,
      ballPosY: ballLogic.ballPosY.value,
      ballXSpeed: ballLogic.ballXSpeed.value,
      ballYSpeed: ballLogic.ballYSpeed.value,
      ballDirectionX: ballLogic.directionX,
      ballDirectionY: ballLogic.directionY,
      topScore: topScore.value,
      bottomScore: bottomScore.value,
    ));
  }

  void _onSyncPlayerPosition() {
    syncPlayerPosition(PlayerPosition(
      playerPosX: _isMaster ? playerBottomPosX.value : playerTopPosX.value,
    ));
  }

  void finishGame(GamePosition gamePosition) {
    ballLogic.finishGame();

    playerPositionTimer.cancel();

    var gameResult = '';
    if ((_isMaster && gamePosition.bottomScore > gamePosition.topScore) ||
        (!_isMaster && bottomScore.value < topScore.value)) {
      gameResult = 'Congratulations!\nYou Win!';
    } else if (gamePosition.bottomScore == gamePosition.topScore) {
      gameResult = 'The points are equal. Friendship! :)';
    } else {
      gameResult = 'You Lose!';
    }

    Get.back(result: gameResult);
  }

  bool get _isMaster => gameside == GameSide.Bottom;

  void setGamePosition(GamePosition gameposition) {
    print('setGamePosition');
    ballLogic.change(BallPosition(
        ballPosX: gameposition.ballPosX,
        ballPosY: gameposition.ballPosY,
        ballXSpeed: gameposition.ballXSpeed,
        ballYSpeed: gameposition.ballYSpeed,
        ballDirectionX: gameposition.ballDirectionX,
        ballDirectionY: gameposition.ballDirectionY));
    topScore.value = gameposition.topScore;
    bottomScore.value = gameposition.bottomScore;
    scoreText.value = '$bottomScore.\nVS\n$topScore';
  }
}
