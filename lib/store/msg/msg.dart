import 'dart:convert';

class Msg {
  int type;
  Map<String, dynamic> data;

  Msg({this.type, this.data});

  Map<String, dynamic> toJson() =>
    {
      'type': type,
      'data': json.encode(data)
    };

}

enum MsgType{
  HEART, 
  ONLINE,
  SENDMESSAGE,
  FRIEND,
  SESSION,
  REQUEST,
  ACKMESSAGE,
  ACK,
}
