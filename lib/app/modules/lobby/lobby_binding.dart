import 'package:flutter_pong_online/app/modules/lobby/lobby_controller.dart';
import 'package:get/get.dart';

class LobbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LobbyController>(
      () => LobbyController(),
    );
  }
}
