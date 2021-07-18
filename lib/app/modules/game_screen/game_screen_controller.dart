import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/data/gameScore.dart';
import 'package:flutter_pong_online/app/data/player_position.dart';
import 'package:flutter_pong_online/app/modules/game_screen/GameLogic/game_logic.dart';
import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/utils/signalr_connection.dart';
import 'package:get/get.dart';

class GameScreenController extends GetxController
    with SingleGetTickerProviderMixin, StateMixin {
  final RxBool isBottom = true.obs;
  final signalRConnection = Get.find<SignalrConnection>();
  late Gamelogic gamelogic;
  var counddownText = 'Waiting for other player'.obs;

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.empty());

    isBottom(Get.arguments == GameSide.Bottom);
    gamelogic = Gamelogic(
        gameSide: Get.arguments,
        updateBallPosition: updateBallPosition,
        updatePlayerGamePosition: updatePlayerGamePosition,
        onScoreChanged: updateGameScore,
        vsync: this);
  }

  void startGame() {
    gamelogic.startGame();
    change(null, status: RxStatus.success());
  }

  void updateBallPosition(BallPosition gameposition) {
    signalRConnection.updateBallPosition(gameposition);
  }

  void updatePlayerGamePosition(PlayerPosition playerPosition) {
    signalRConnection.updatePlayerGamePosition(playerPosition);
  }

  void updateGameScore(GameScore gameScore) {
    signalRConnection.updateGameScore(gameScore);
  }

  void setOpponentPlayerPosition(PlayerPosition playerPosition) {
    gamelogic.setOpponentPlayerPosition(playerPosition);
  }

  void setScores({required int topScore, required int bottomScore}) {
    gamelogic.setScores(topScore: topScore, bottomScore: bottomScore);
  }

  void setGamePosition(BallPosition ballPosition) {
    gamelogic.setBallPosition(ballPosition);
  }

  void beforeStartCountdown(String beforestart) {
    if (status != RxStatus.loading()) {
      change(null, status: RxStatus.loading());
    }
    counddownText.value = 'Start in $beforestart';
  }

  void finishGame(GameScore gamePosition) {
    gamelogic.finishGame(gamePosition);
    change(null, status: RxStatus.empty());
  }
}
