class BallPosition {
  final double ballPosX;
  final double ballPosY;
  final double ballXSpeed;
  final double ballYSpeed;
  final int ballDirectionX;
  final int ballDirectionY;

  BallPosition(
      {required this.ballPosX,
      required this.ballPosY,
      required this.ballXSpeed,
      required this.ballYSpeed,
      required this.ballDirectionX,
      required this.ballDirectionY});
}

typedef BallPositionFunc = void Function(BallPosition);

typedef OnHitFunc = void Function(Side);

enum Side { Top, Right, Bottom, Left }
