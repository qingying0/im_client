import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/db/message_dao.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/msg/enums.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

var socketManage = new SocketManager();

class SocketManager {
  Socket socket;
  bool isDone;
  bool isOnline;
  bool heart;
  Timer onlineTimer;
  Timer heartTimer;
  BuildContext context;
  SocketManager() {
    isDone = true;
    isOnline = false;
    heart = true;
    heartTimer = new Timer.periodic(new Duration(seconds: 60), (timer) {
      if(heart == false) {
        isDone = true;
      }
      if(isOnline == true) {
        if(isDone == false) {
          Map map = new Map();
          map['type'] = SendMsgType.HEART.index;
          sendMsg(json.encode(map));
          heart = false;
        } else {
          conn();
        }
      }
    });
  }


  setContext(BuildContext context) {
    this.context = context;
  }

  getContext() {
    return context;
  }

  void conn() async{
    try {
      socket = await Socket.connect(GlobalConfig.nettyIp, GlobalConfig.nettyPort);
      String token = await sharedGetData("token");
      sendOnline(token);
      isDone = false;
      heart = true;
    } catch (e) {
      print("连接出错");
      socket.close();
    }
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  }

  void dataHandler(data){
    var value = utf8.decode(data);
    print("value = " + value);
    var map = json.decode(value);
    switch(map['type']) {
      case 0:
//        print("heart = true");
        heart = true;
        break;
      case 1:
        print("isDone = false");
        isDone = false;
        break;
      case 2:
        print("receive message map = " + map.toString());
        messageHandler(map['data']);
        break;
      default:
        break;
    }
  }

  void errorHandler(error, StackTrace trace){
    print(error);
    isDone = true;
  }

  void doneHandler(){
    socket.destroy();
    isDone = true;
  }

  void sendMsg(data) {
    print("发送" + data);
    socket.writeln(data);
  }

  void sendOnline(token) {
    Map send = new Map();
    send['type'] = SendMsgType.ONLINE.index;
    send['token'] = token;
    sendMsg(json.encode(send));
  }

  void sendOffLine() {
    Map send = new Map();
    send['type'] = SendMsgType.OFFLINE.index;
    sendMsg(json.encode(send));
  }

  void messageHandler(Map map) async {
    if (map['type'] == 0) {
      Message message = new Message(
        id: map['id'],
        sendId: map['sendId'],
        sessionId: map['sessionId'],
        type: map['type'],
        createTime: DateTime.fromMicrosecondsSinceEpoch(map['createTime']),
        content: map['content'],
        status: map['status'],
        username: map['username'],
        avatarUrl: map['avatarUrl'],
      );
      messageDao.insert(message);
      Store.value<MessageProvider>(context).addMessageBySessionId(message);
      Store.value<SessionProvider>(context).updateByReceivedMessage(message);
      Map send = new Map();
      send['type'] = SendMsgType.ACK_MESSAGE.index;
      send['id'] = map['id'];
      sendMsg(json.encode(send));
    }else if(map['type'] == 2){
      String downLoad = map['content'];
      Directory dir = await getApplicationDocumentsDirectory();
      String fileName = Uuid().v4().toString() + '.wav';
      String filePath = dir.path + "/" + fileName;
      Dio dio = new Dio();
      print("download = " + downLoad);
      dio.download(downLoad, filePath);
      Message message = new Message(
        id: map['id'],
        sendId: map['sendId'],
        sessionId: map['sessionId'],
        type: map['type'],
        createTime: DateTime.fromMicrosecondsSinceEpoch(map['createTime']),
        content: filePath,
        status: map['status'],
        username: map['username'],
        avatarUrl: map['avatarUrl'],
      );
      messageDao.insert(message);
      Store.value<MessageProvider>(context).addMessageBySessionId(message);
      Store.value<SessionProvider>(context).updateByReceivedMessage(message);
      Map send = new Map();
      send['type'] = SendMsgType.ACK_MESSAGE.index;
      send['id'] = map['id'];
      sendMsg(json.encode(send));
    }
  }
}
