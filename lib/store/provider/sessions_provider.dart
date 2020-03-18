import 'dart:math';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/socket/socket_manager.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

class SessionProvider with ChangeNotifier {

  List<Session> _listSession = new List<Session>();
  Map<int ,Session> _mapSession = new Map();
  bool initdata = false;

  List get listSession => _listSession;
  Map get mapSession => _mapSession;

  getSessionIdByUserId(int id) {
    for(Session session in _listSession) {
      if(session.targetId == id) {
        return session.sessionId;
      }
    }
    return null;
  }

  getRandomTime() {
    int rand = Random().nextInt(1000000000);
    DateTime now = DateTime.now();
    DateTime randomDateTime = DateTime.fromMicrosecondsSinceEpoch(now.microsecondsSinceEpoch - rand);
    return getTime(randomDateTime);
  }

  getTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateTime);
    if(diff.inDays > 0) {
      return "${diff.inDays}天前";
    } else if(diff.inHours > 0) {
      return "${diff.inHours}小时前";
    } else if(diff.inMinutes > 0) {
      return "${diff.inMinutes}分钟前";
    } else {
      return "刚刚";
    }
  }

  getSession(int session) {
    return _mapSession[session];
  }

  getMessage(int session) {
    return _mapSession[session].listMessageId;
  }

  addMessage(int session, int messageId) {
    _mapSession[session].listMessageId.add(messageId);
    notifyListeners();
  }

  updateByReceivedMessage(Message message) {
    _mapSession[message.sessionId].unreadnum++;
    if(message.type == 0) {
      _mapSession[message.sessionId].content = message.content;
    } else if(message.type == 2) {
      _mapSession[message.sessionId].content = "语音";
    }
    _mapSession[message.sessionId].updateTime = getTime(DateTime.now());
    notifyListeners();
  }

  updateContent(Message message) {
    if(message.type == 0) {
      _mapSession[message.sessionId].content = message.content;
    } else if(message.type == 2) {
      _mapSession[message.sessionId].content = "语音";
    }
    notifyListeners();
  }

  clear() {
    _listSession.clear();
    _mapSession.clear();
  }

  init() async{
    if(GlobalConfig.initSession == false) {
      GlobalConfig.initSession = true;
      _listSession.clear();
      _mapSession.clear();
      Dio dio = new Dio();
      dio.options = new Options(
        headers : {
          "token": await sharedGetData("token"),
        });
      var response = await dio.get("http://" + GlobalConfig.address + "/session");
      if(response.data['code'] == 200) {
        List sessions = response.data['data'];
        for (Map session in sessions) {
          Session s = new Session(
            id: session.containsKey("id") ? session['id'] : null,
            sessionId: session.containsKey("sessionId") ? session['sessionId'] : null,
            targetId: session.containsKey("targetId") ? session['targetId'] : null,
            nickName: session.containsKey("nickname") ? session['nickname'] : null,
            content: session.containsKey("content") ? session['content'] : null,
            avatarUrl: null,
            updateTime: getTime(DateTime.parse(session['updateTime'])),
            unreadnum: session.containsKey("unreadNum") ? session['unreadNum'] : null,
          );
          _listSession.add(s);
          _mapSession[s.sessionId] = s;
        }
        notifyListeners();
      }
      socketManage.isOnline = true;
      socketManage.conn();
    }
  }

  clearUnreadSession(int sessionId) {
    _mapSession[sessionId].unreadnum = 0;
  }

}
