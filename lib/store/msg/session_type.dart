

import 'dart:convert';

class SessionMsg {
  int type;
  Object data;
  
  SessionMsg({this.type, this.data});

    Map<String, dynamic> toJson() =>
    {
      'type': type,
      'data': json.encode(data)
    };
}

enum SessionTypeEnum {
  OPEN,
}