
class Message {
  int id;
  int sendId;
  int sessionId;
  int type;
  DateTime createTime;
  String content;
  int status;
  Message({this.id, this.sendId, this.sessionId, this.type,this.createTime, this.content, this.status});

  @override
  String toString() {
    return 'Message{id: $id, sendId: $sendId, sessionId: $sessionId, type: $type, createTime: $createTime, content: $content, status: $status}';
  }

}
