import 'dart:async';
import 'dart:convert';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/db/message_dao.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/msg/ack_msg.dart';
import 'package:chat/store/msg/message_msg.dart';
import 'package:chat/store/msg/msg.dart';
import 'package:chat/store/msg/online_msg.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dio/dio.dart';

var webSocket = new WebSocket();


class WebSocket {
  // webSocket连接
  IOWebSocketChannel webSocketChannel;
  BuildContext context;

  factory WebSocket() => _webSocket();

  static WebSocket _instance;
  bool isDone;
  bool isOnline;
  bool heart;
  Timer onlineTimer;
  Timer heartTimer;
  // 构造函数
  WebSocket._() {
    // 初始化webSocket路由
    isDone = false;
    isOnline = false;
    heart = true;
    conn();
    onlineTimer = new Timer.periodic(new Duration(seconds: 5), (timer) {
      if(isOnline == true && isDone == true) {
        conn();
        var id = Store.value<UserInfoProvider>(context).id;
        webSocket.sendMsg(new Msg(type: MsgType.ONLINE.index, data: OnlineMsg(type: OnlineEnum.ONLINE.index, userId: id).toJson()).toJson());
      }
    });
    heartTimer = new Timer.periodic(new Duration(seconds: 10), (timer) {
      if(heart = false) {
        isDone = true;
      }
      if(isOnline == true && isDone == false) {
        webSocket.sendMsg(new Msg(type: MsgType.HEART.index).toJson());
      }
      heart = false;
    });
  }

  static WebSocket _webSocket() {
    if (_instance == null) {
      _instance = WebSocket._();
    }
    return _instance;
  }

  setContext(BuildContext context) {
    this.context = context;
  }

  conn() {
    IOWebSocketChannel channel = new IOWebSocketChannel.connect(
        GlobalConfig.wsPath,
        pingInterval: Duration(milliseconds: 100));
    channel.stream
        .listen((data) => onMsg(data), onError: onError, onDone: onDone,);
    this.webSocketChannel = channel;
  }

  sendMsg(data) {
    print("websocket send " + data.toString());
    webSocketChannel.sink.add(json.encode(data));
  }

  onMsg(response) async {
    print("response = ");
    print(response);
    Map param = json.decode(response);
    if(param['type'] == 1) {
      receivedLoginMessageHandler(param['data']);
    }
    if(param['type'] == 2) {
      receivedMessageHandler(param['data']);
    }
    if(param['type'] == 3) {
      
    }
    if(param['type'] == 6) {
      ackMessageHandler(param['data']);
    }
    if(param['type'] == 7) {
      ackOnline(param['data']);
    }
  }

  onError(err) async {
    print("websocket on error" + err.toString());
    isDone = true;
  }

  onDone() async {
    print("websocket on done");
    isDone = true;
  }

  receivedLoginMessageHandler(Map data) {
    Message message = new Message(
      id: data['id'], 
      sendId: data['sendId'], 
      sessionId: data['sessionId'], 
      type: data['type'], 
      createTime: DateTime.fromMicrosecondsSinceEpoch(data['createTime']), 
      content: data['content'], 
      status: data['status'], 
    );
    webSocket.sendMsg(new Msg(type: MsgType.ACK.index, data: new AckMsg(type: AckType.MESSAGE.index, id: message.id).toJson()).toJson());
    messageDao.insert(message);
  }

  receivedMessageHandler(Map data) {
    Message message = new Message(
      id: data['id'], 
      sendId: data['sendId'], 
      sessionId: data['sessionId'], 
      type: data['type'], 
      createTime: DateTime.fromMicrosecondsSinceEpoch(data['createTime']), 
      content: data['content'], 
      status: data['status'], 
    );
    webSocket.sendMsg(new Msg(type: MsgType.ACK.index, data: new AckMsg(type: AckType.MESSAGE.index, id: message.id).toJson()).toJson());
    messageDao.insert(message);
    Store.value<MessageProvider>(context).addMessageBySessionId(message);
    Store.value<SessionProvider>(context).addUnReadNum(message);
    Store.value<SessionProvider>(context).updateContent(message);
  }

  ackMessageHandler(Map data) {
    Message message = new Message(
      id: data['id'], 
      sendId: data['sendId'], 
      sessionId: data['sessionId'], 
      type: data['type'], 
      createTime: DateTime.fromMicrosecondsSinceEpoch(data['createTime']), 
      content: data['content'], 
      status: data['status'], 
    );
    messageDao.insert(message);
    Store.value<MessageProvider>(context).addMessageBySessionId(message);
    Store.value<SessionProvider>(context).updateContent(message);
  }

  ackOnline(Map data) {
    if(data['type'] == 0) {
      isDone = false;
    } else if(data['type'] == 1) {
      heart = true;
    }
  }

}
