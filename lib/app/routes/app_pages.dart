import 'package:flutter_pong_online/app/modules/lobby/lobby_binding.dart';
import 'package:get/get.dart';

import 'package:flutter_pong_online/app/modules/game_screen/game_screen_binding.dart';
import 'package:flutter_pong_online/app/modules/game_screen/game_screen_view.dart';
import 'package:flutter_pong_online/app/modules/lobby/lobby_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOBBY;

  static final routes = [
    GetPage(
      name: _Paths.GAME_SCREEN,
      page: () => GameScreenView(),
      binding: GameScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOBBY,
      page: () => LobbyView(),
      binding: LobbyBinding(),
    ),
  ];
}
