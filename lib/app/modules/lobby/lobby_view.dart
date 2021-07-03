import 'package:flutter_pong_online/app/modules/game_screen/widgets/player_widget.dart';
import 'package:flutter_pong_online/app/modules/lobby/lobby_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LobbyView extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LobbyView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() => Center(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.gameResult.value,
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.isBottomAvailiable.value)
                          ElevatedButton(
                              onPressed: () {
                                controller.takeGameSide(GameSide.Bottom);
                              },
                              child: Text('Start Game at the Bottom')),
                        if (controller.isTopAvailiable.value)
                          ElevatedButton(
                              onPressed: () {
                                controller.takeGameSide(GameSide.Top);
                              },
                              child: Text('Start Game at Top'))
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
