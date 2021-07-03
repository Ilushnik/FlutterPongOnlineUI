import 'package:flutter_pong_online/app/data/player_position.dart';
import 'package:flutter_pong_online/app/data/game_position.dart';
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
        gameside: Get.arguments,
        syncGamePosition: syncGamePosition,
        syncPlayerPosition: syncPlayerPosition,
        vsync: this);
  }

  void syncGamePosition(GamePosition gameposition) {
    signalRConnection.updateGamePosition(gameposition);
  }

  void syncPlayerPosition(PlayerPosition playerPosition) {
    signalRConnection.batGamePosition(playerPosition);
  }

  void setOpponentPlayerPosition(PlayerPosition gameposition) {
    if (isBottom.isTrue) {
      gamelogic.playerTopPosX.value = gameposition.playerPosX;
    } else {
      gamelogic.playerBottomPosX.value = gameposition.playerPosX;
    }
  }

  void startGame() {
    gamelogic.startGame();
    change(null, status: RxStatus.success());
    // isGameInProcess(true);
  }

  void finishGame(GamePosition gamePosition) {
    gamelogic.finishGame(gamePosition);
    change(null, status: RxStatus.empty());
    // isGameInProcess(false);
  }

  void setGamePosition(GamePosition gameposition) {
    gamelogic.setGamePosition(gameposition);
  }

  void beforeStartCountdown(String beforestart) {
    if (status != RxStatus.loading()) {
      change(null, status: RxStatus.loading());
    }
    counddownText.value = 'Start in $beforestart';
  }
}
