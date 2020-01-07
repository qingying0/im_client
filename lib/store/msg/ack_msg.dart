class AckMsg {
  int type;
  int id;
  int status;

  AckMsg({this.id, this.status, this.type});

  Map<String, dynamic> toJson() =>
  {
    'type': type,
    'id': id,
    'status': status,
  };
}

enum AckType{
  MESSAGE,
}