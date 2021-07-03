import 'dart:math';

import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/routes/app_pages.dart';
import 'package:flutter_pong_online/app/utils/signalr_connection.dart';
import 'package:get/get.dart';

class LobbyController extends GetxController {
  var userName = ''.obs;
  var isTopAvailiable = true.obs;
  var isBottomAvailiable = true.obs;
  var gameResult = ''.obs;

  @override
  void onReady() {
    super.onReady();
    Get.find<SignalrConnection>().getTakenGameSide();
    userName.value = 'User_' + Random().nextInt(200).toString();
  }

  void login(GameSide side) {
    Get.find<SignalrConnection>()
        .login(userName.value, side.toString().split('.')[1]);
  }

  void connectedUsersChanged(List<String> users) {
    isTopAvailiable.value = !users.any((element) => element == 'Top');
    isBottomAvailiable.value = !users.any((element) => element == 'Bottom');
  }

  Future<void> takeGameSide(GameSide side) async {
    login(side);
    var result = await Get.toNamed(Routes.GAME_SCREEN, arguments: side);
    gameResult.value = result as String;
  }
}
