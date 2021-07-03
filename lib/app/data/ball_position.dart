class BallPosition {
  late double ballPosX;
  late double ballPosY;
  late double ballXSpeed;
  late double ballYSpeed;
  late int ballDirectionX;
  late int ballDirectionY;

  BallPosition({
    required this.ballPosX,
    required this.ballPosY,
    required this.ballXSpeed,
    required this.ballYSpeed,
    required this.ballDirectionX,
    required this.ballDirectionY,
  });

  Map<String, dynamic> toJson() {
    return {
      'ballPosX': ballPosX,
      'ballPosY': ballPosY,
      'ballXSpeed': ballXSpeed,
      'ballYSpeed': ballYSpeed,
      'ballDirectionX': ballDirectionX,
      'ballDirectionY': ballDirectionY,
    };
  }

  BallPosition.fromJson(Map<String, dynamic> json) {
    ballPosX = double.parse(json['ballPosX'].toString());
    ballPosY = double.parse(json['ballPosY'].toString());
    ballXSpeed = double.parse(json['ballXSpeed'].toString());
    ballYSpeed = double.parse(json['ballYSpeed'].toString());
    ballDirectionX = json['ballDirectionX'];
    ballDirectionY = json['ballDirectionY'];
  }
}
