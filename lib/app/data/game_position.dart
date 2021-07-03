class GamePosition {
  late double ballPosX;
  late double ballPosY;
  late double ballXSpeed;
  late double ballYSpeed;
  late int ballDirectionX;
  late int ballDirectionY;
  late int topScore;
  late int bottomScore;

  GamePosition(
      {
      required this.ballPosX,
      required this.ballPosY,
      required this.ballXSpeed,
      required this.ballYSpeed,
      required this.ballDirectionX,
      required this.ballDirectionY,
      required this.topScore, 
      required this.bottomScore});

  Map<String, dynamic> toJson() {
    return {
      'ballPosX': ballPosX,
      'ballPosY': ballPosY,
      'ballXSpeed': ballXSpeed,
      'ballYSpeed': ballYSpeed,
      'ballDirectionX': ballDirectionX,
      'ballDirectionY': ballDirectionY,
      'topScore': topScore,
      'bottomScore': bottomScore,
    };
  }

  GamePosition.fromJson(Map<String, dynamic> json) {
    ballPosX = double.parse(json['ballPosX'].toString());
    ballPosY = double.parse(json['ballPosY'].toString());
    ballXSpeed = double.parse(json['ballXSpeed'].toString());
    ballYSpeed = double.parse(json['ballYSpeed'].toString());
    ballDirectionX = json['ballDirectionX'];
    ballDirectionY = json['ballDirectionY'];
    topScore = json['topScore'];
    bottomScore = json['bottomScore'];
  }
}
