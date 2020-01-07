
class MessageMsg {
  int sendId;
  int sessionId;
  int targetId;
  int type;
  String content;

  MessageMsg({this.sendId, this.sessionId, this.content, this.type, this.targetId});

  Map<String, dynamic> toJson() =>
  {
    'sendId': sendId,
    'sessionId': sessionId,
    'targetId': targetId,
    'type': type,
    'content': content,
  };
}