import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final double posX;
  final double paddingY;
  final GameSide gameSide;
  final double width;
  final double height;
  final Function onPosXChanged;
  final Function onPosXChanging;
  final GameSide playerSide;
  final int playerUpdateInMiliseconds;

  const Player({
    Key? key,
    required this.posX,
    required this.paddingY,
    required this.gameSide,
    required this.width,
    required this.height,
    required this.onPosXChanged,
    required this.onPosXChanging,
    required this.playerSide,
    required this.playerUpdateInMiliseconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: playerUpdateInMiliseconds),
      left: posX,
      bottom: gameSide == GameSide.Bottom ? paddingY : null,
      top: gameSide == GameSide.Top ? paddingY : null,
      child: gameSide == playerSide
          ? Draggable(
              childWhenDragging: Container(),
              axis: Axis.horizontal,
              affinity: Axis.horizontal,
              feedback: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[500]),
              ),
              onDragEnd: (details) {
                onPosXChanged(details.offset.dx);
              },
              onDragUpdate: (DragUpdateDetails details) {
                onPosXChanging(details.delta.dx);
              },
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[500]),
              ),
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(5)),
            ),
    );
  }
}

enum GameSide { Top, Bottom }
