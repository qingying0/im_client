class Request {
  int id;
  String username;
  String content;
  int type;
  int status;
  String avatarUrl;

  Request({this.id, this.username, this.content, this.avatarUrl, this.type, this.status});
}

enum ReuqestEnum{
  SEND,
  SUCCESS,
  FAILD,
}