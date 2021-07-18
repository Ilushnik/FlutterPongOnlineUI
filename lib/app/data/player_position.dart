class PlayerPosition {
  late double playerPosX;
  late bool isBallHit;

  PlayerPosition({required this.playerPosX, required this.isBallHit});

  Map<String, dynamic> toJson() {
    return {
      'playerPosX': playerPosX,
      'isBallHit': isBallHit,
    };
  }

  PlayerPosition.fromJson(Map<String, dynamic> json) {
    playerPosX = double.parse(json['playerPosX'].toString());
    isBallHit = json['isBallHit'];
  }
}
