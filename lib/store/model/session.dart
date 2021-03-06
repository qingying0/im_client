

class Session {
  int id;
  int targetId;
  int sessionId;
  String nickName;
  String content;
  String avatarUrl;
  String updateTime;
  int unreadnum;
  int sessionType;
  List<int> listMessageId;
  int status;

  Session({this.sessionId, this.targetId, this.nickName, this.avatarUrl, this.content, this.unreadnum, this.updateTime, this.sessionType, this.listMessageId, this.status, this.id});

  @override
  String toString() {
    return 'Session{id: $id, targetId: $targetId, sessionId: $sessionId, nickName: $nickName, content: $content, avatarUrl: $avatarUrl, updateTime: $updateTime, unreadnum: $unreadnum, sessionType: $sessionType, listMessageId: $listMessageId, status: $status}';
  }


}
