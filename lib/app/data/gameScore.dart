class GameScore {
  late int topScore;
  late int bottomScore;

  GameScore({required this.topScore, required this.bottomScore});

  Map<String, dynamic> toJson() {
    return {
      'topScore': topScore,
      'bottomScore': bottomScore,
    };
  }

  GameScore.fromJson(Map<String, dynamic> json) {
    topScore = json['topScore'];
    bottomScore = json['bottomScore'];
  }
}
