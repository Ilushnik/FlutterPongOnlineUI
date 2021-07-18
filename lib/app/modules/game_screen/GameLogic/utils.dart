import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/data/gameScore.dart';

typedef BallPositionFunc = void Function(BallPosition);
typedef GameScoreFunc = void Function(GameScore);

typedef OnHitFunc = void Function(Side);

enum Side { Top, Right, Bottom, Left }

typedef OnPlayerMadeAHit = void Function(
    {required BallPosition currentBallPosition,
    required double newBallXSpeed,
    required int newDirectionX,
    required int newDirectionY});
