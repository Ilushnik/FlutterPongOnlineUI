import 'dart:async';
import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/data/gameScore.dart';
import 'package:flutter_pong_online/app/data/player_position.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/ball_Logic.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/collusion_detection.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/utils.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:get/get.dart';

class Gamelogic {
  final RxDouble playerBottomPosX = 0.0.obs;
  final RxDouble playerTopPosX = 0.0.obs;

  final RxDouble playerPaddingY = 20.0.obs;
  final RxDouble playerHeight = 10.0.obs;
  final RxDouble playerWidth = 120.0.obs;

  late GameSide gameSide;
  late BallPositionFunc updateBallPosition;
  late Function updatePlayerGamePosition;
  late GameScoreFunc onScoreChanged;

  late Timer playerPositionTimer;

  final bottomScore = 0.obs;
  final topScore = 0.obs;

  static const int playersSyncInMilisecondsConst = 500;
  final RxInt playersSyncInMiliseconds = 500.obs;

  late BallLogic ballLogic;
  late CollusionDetection _collusionDetection;

  RxString scoreText = ''.obs;
  late var scoreFromServer = ''.obs;

  Gamelogic(
      {required this.gameSide,
      required this.updateBallPosition,
      required this.updatePlayerGamePosition,
      required this.onScoreChanged,
      required vsync}) {
    ballLogic = BallLogic(
      vsync: vsync,
      onBallPositionChanged: onBallPositionChanged,
      onHitFunc: onBallHitBound,
    );
    playerPositionTimer = Timer.periodic(
        Duration(milliseconds: playersSyncInMilisecondsConst),
        (t) => _onSyncPlayerPosition(isBallHit: false));

    _collusionDetection = CollusionDetection(
        gameSide,
        playerPaddingY.value,
        playerHeight.value,
        playerWidth.value,
        ballLogic.ballDiameter,
        onPlayerMadeAHit);
  }

  void onBallHitBound(Side side) {
    if (gameSide == GameSide.Bottom && side != Side.Bottom ||
        gameSide == GameSide.Top && side != Side.Top) return;

    if (side == Side.Bottom) {
      topScore.value++;
      onScoreChanged(
          GameScore(topScore: topScore.value, bottomScore: bottomScore.value));
    } else if (side == Side.Top) {
      bottomScore.value++;
      onScoreChanged(
          GameScore(topScore: topScore.value, bottomScore: bottomScore.value));
    }
  }

  void onPlayerMadeAHit(
      {required BallPosition currentBallPosition,
      required double newBallXSpeed,
      required int newDirectionX,
      required int newDirectionY}) {
    ballLogic.change(BallPosition(
        ballPosX: ballLogic.ballPosX.value,
        ballPosY: ballLogic.ballPosY.value,
        ballXSpeed: newBallXSpeed,
        ballYSpeed: ballLogic.ballYSpeed.value,
        ballDirectionX: newDirectionX,
        ballDirectionY: newDirectionY));
    _updateGamePositionToServer();
    _onSyncPlayerPosition(isBallHit: true);
  }

  void onBallPositionChanged(BallPosition ballPosition) {
    _collusionDetection.checkCollusion(
        ballPosition,
        gameSide == GameSide.Bottom
            ? playerBottomPosX.value
            : playerTopPosX.value,
        playerPaddingY);
  }

  void startGame() {
    ballLogic.startGame();
    if (_isBottom) _updateGamePositionToServer();
  }

  void _updateGamePositionToServer() {
    updateBallPosition(BallPosition(
      ballPosX: ballLogic.ballPosX.value,
      ballPosY: ballLogic.ballPosY.value,
      ballXSpeed: ballLogic.ballXSpeed.value,
      ballYSpeed: ballLogic.ballYSpeed.value,
      ballDirectionX: ballLogic.directionX,
      ballDirectionY: ballLogic.directionY,
    ));
  }

  void _onSyncPlayerPosition({required bool isBallHit}) {
    updatePlayerGamePosition(PlayerPosition(
        playerPosX: _isBottom ? playerBottomPosX.value : playerTopPosX.value,
        isBallHit: isBallHit));
  }

  bool get _isBottom => gameSide == GameSide.Bottom;

  void setBallPosition(BallPosition ballPosition) {
    print('Sync ball position');

    ballLogic.change(BallPosition(
        ballPosX: ballPosition.ballPosX,
        ballPosY: ballPosition.ballPosY,
        ballXSpeed: ballPosition.ballXSpeed,
        ballYSpeed: ballPosition.ballYSpeed,
        ballDirectionX: ballPosition.ballDirectionX,
        ballDirectionY: ballPosition.ballDirectionY));
  }

  void setScores(GameScore gameScore) {
    this.topScore.value = gameScore.topScore;
    this.bottomScore.value = gameScore.bottomScore;
    scoreText.value = '$bottomScore.\nVS\n$topScore';
  }

  void setOpponentPlayerPosition(PlayerPosition opponentPlayerPosition) {
    playersSyncInMiliseconds.value = opponentPlayerPosition.isBallHit
        ? 100
        : Gamelogic.playersSyncInMilisecondsConst;
    if (gameSide == GameSide.Bottom) {
      playerTopPosX.value = opponentPlayerPosition.playerPosX;
    } else {
      playerBottomPosX.value = opponentPlayerPosition.playerPosX;
    }
  }

  void finishGame(GameScore gamePosition) {
    ballLogic.finishGame();

    playerPositionTimer.cancel();

    var gameResult = '';
    if ((_isBottom && gamePosition.bottomScore > gamePosition.topScore) ||
        (!_isBottom && bottomScore.value < topScore.value)) {
      gameResult = 'Congratulations!\nYou Win!';
    } else if (gamePosition.bottomScore == gamePosition.topScore) {
      gameResult = 'The points are equal. Friendship! :)';
    } else {
      gameResult = 'You Lose!';
    }

    Get.back(result: gameResult);
  }
}
