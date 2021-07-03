import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/data/gameScore.dart';
import 'package:flutter_pong_online/app/data/player_position.dart';
import 'package:flutter_pong_online/app/data/user.dart';
import 'package:flutter_pong_online/app/modules/game_screen/game_screen_controller.dart';
import 'package:flutter_pong_online/app/modules/lobby/lobby_controller.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalrConnection extends ChangeNotifier {
  static late HubConnection connection;

  Future<void> startConnection() async {
    await recreateConnecton();
    print('Connection Started');
  }

  Future recreateConnecton() async {
    print('SignalrConnection.StartConnection.');

    connection = HubConnectionBuilder()
        .withUrl(
            'http://localhost:5006/PongGameHub',
            HttpConnectionOptions(
              skipNegotiation: true,
              transport: HttpTransportType.webSockets,
              client: IOClient(
                  HttpClient()..badCertificateCallback = (x, y, z) => true),
              logging: (level, message) => print(message),
            ))
        .build();

    connection.onclose((exception) async {
      await retryUntilSuccessfulConnection(exception);
    });

    connection.on('StartGame', (message) {
      print('StartGame');
      Get.find<GameScreenController>().startGame();
    });

    connection.on('StartGameCountdown', (message) {
      print('StartGameCountdown');
      var beforestart = message![0].toString();
      Get.find<GameScreenController>().beforeStartCountdown(beforestart);
    });

    connection.on('GetConnectedUsers', (message) {
      print('GetConnectedUsers');
      var users = User.listFromJson(message![0]);
      var busySides = <String>[];
      users.forEach((element) {
        busySides.add(element.playerPosition);
      });
      Get.find<LobbyController>().connectedUsersChanged(busySides);
    });

    connection.on('GetTakenGameSide', (message) {
      print('GetTakenGameSide incoming');
      var busySides = (message![0] as List<dynamic>).cast<String>();
      Get.find<LobbyController>().connectedUsersChanged(busySides);
    });

    connection.on('PlayerMakeAGoal', (message) {
      print('PlayerMakeAGoal incoming');
      var ballPosition =
          GameScore.fromJson(message![0] as Map<String, dynamic>);
      Get.find<GameScreenController>().syncScores(
          topScore: ballPosition.topScore,
          bottomScore: ballPosition.bottomScore);
    });

    connection.on('UpdateGamePosition', (message) {
      print('UpdateGamePosition incoming');
      var ballPosition =
          BallPosition.fromJson(message![0] as Map<String, dynamic>);
      Get.find<GameScreenController>().setGamePosition(ballPosition);
    });

    connection.on('UpdatePlayerPosition', (message) {
      print('UpdatePlayerPosition incoming');
      var ballPosition =
          PlayerPosition.fromJson(message![0] as Map<String, dynamic>);
      Get.find<GameScreenController>().setOpponentPlayerPosition(ballPosition);
    });

    connection.on('FinishGame', (message) {
      print('FinishGame incoming');
      var ballPosition =
          GameScore.fromJson(message![0] as Map<String, dynamic>);
      Get.find<GameScreenController>().finishGame(ballPosition);
    });

    await connection.start();
  }

  Future retryUntilSuccessfulConnection(Exception? exception) async {
    while (true) {
      var delayTime = Random().nextInt(20);
      await Future.delayed(Duration(seconds: delayTime));

      try {
        await recreateConnecton();

        if (connection.state == HubConnectionState.connected) {
          notifyListeners();
          return;
        }
      } catch (e) {
        print('Exception here :( ${e.toString()}');
      } finally {
        print('finally:');
      }
    }
  }

  void login(String userName, String position) {
    connection.invoke('login', args: [userName, position]);
  }

  void updateBallPosition(BallPosition ballPosition) {
    print('updateGamePosition outgoing');
    connection.invoke('UpdateGamePosition', args: [ballPosition.toJson()]);
  }

  void updatePlayerGamePosition(PlayerPosition playerPosition) {
    print('UpdatePlayerPosition outgoing');
    connection.invoke('UpdatePlayerPosition', args: [playerPosition.toJson()]);
  }

  void getTakenGameSide() {
    print('GetTakenGameSide outgoing');
    connection.invoke(
      'GetTakenGameSide',
    );
  }

  void updateGameScore(GameScore gameScore) {
    print('updateGaneScore outgoing');
    connection.invoke('PlayerMakeAGoal', args: [gameScore.toJson()]);
  }
}
