
class OnlineMsg{
  int userId;
  int type;
  // online 0
  // offline 1
    Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'type': type,
    };
  OnlineMsg({this.type, this.userId});
}

enum OnlineEnum {
  ONLINE,
  OFFLINE
}
