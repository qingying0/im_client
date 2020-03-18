
class Message {
  int id;
  int sendId;
  int sessionId;
  int targetId;
  int type;
  DateTime createTime;
  String content;
  int status;
  String username;
  String avatarUrl;
  Message({this.id, this.sendId, this.sessionId, this.type,this.createTime, this.content, this.status, this.avatarUrl, this.username, this.targetId});

  @override
  String toString() {
    return 'Message{id: $id, sendId: $sendId, sessionId: $sessionId, type: $type, createTime: $createTime, content: $content, status: $status, username: $username, avatarUrl: $avatarUrl}';
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "send_id": sendId,
      "session_id": sessionId,
      "type": type,
      "create_time": createTime.millisecondsSinceEpoch,
      "content": content,
      "status": status,
      "username" :username,
      "avatar_url": avatarUrl,
    };
    return map;
  }

}
