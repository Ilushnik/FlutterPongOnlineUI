import 'package:flutter_pong_online/app/data/ball_position.dart';
import 'package:flutter_pong_online/app/data/gameScore.dart';

typedef BallPositionFunc = void Function(BallPosition);
typedef GameScoreFunc = void Function(GameScore);

typedef OnHitFunc = void Function(Side);

enum Side { Top, Right, Bottom, Left }
