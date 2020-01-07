

class Session {
  int id;
  int userId;
  int sessionId;
  String nickName;
  String content;
  String avatarUrl;
  String updateTime;
  int unreadnum;
  int sessionType;
  List<int> listMessageId;
  int status;

  Session({this.sessionId, this.userId, this.nickName, this.avatarUrl, this.content, this.unreadnum, this.updateTime, this.sessionType, this.listMessageId, this.status, this.id});

  setContent(content) {
    this.content = content;
  }
}
