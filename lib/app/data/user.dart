class User {
  late String connectionID;
  late String userName;
  late String playerPosition;

  User(
      {required this.connectionID,
      required this.userName,
      required this.playerPosition});

  Map<String, dynamic> toJson() {
    return {
      'connectionID': connectionID,
      'ballPosX': userName,
      'ballPosY': playerPosition,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    connectionID = json['connectionID'];
    userName = json['userName'];
    playerPosition = json['playerPosition'];
  }

  static List<User> listFromJson(list) =>
      List<User>.from(list.map((x) => User.fromJson(x)));
}