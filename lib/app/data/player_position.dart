class PlayerPosition {
  late double playerPosX;

  PlayerPosition({required this.playerPosX});

  Map<String, dynamic> toJson() {
    return {
      'playerPosX': playerPosX,
    };
  }

  PlayerPosition.fromJson(Map<String, dynamic> json) {
    playerPosX = double.parse(json['playerPosX'].toString());
  }
}
