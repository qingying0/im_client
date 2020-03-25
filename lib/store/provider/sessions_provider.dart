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

  get listSession => _listSession;

  getSessionByUserId(int id) {
    for(Session session in _listSession) {
      if(session.targetId == id && session.sessionType == 0) {
        return session;
      }
    }
    return null;
  }

  getSessionByGroupId(int id) {
    for(Session session in _listSession) {
      if(session.targetId == id && session.sessionType == 1) {
        return session;
      }
    }
    return null;
  }

  getSessionBySessionId(int id) {
    for(Session session in _listSession) {
      if(session.sessionId == id) {
        return session;
      }
    }
    return null;
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

  updateByReceivedMessage(Message message) {
    for(Session session in _listSession) {
      if(session.sessionId == message.sessionId) {
        session.unreadnum++;
        if(message.type == 0) {
          session.content = message.content;
        } else if(message.type == 2) {
          session.content = "语音";
        }
        session.updateTime = getTime(DateTime.now());
      }
    }
    notifyListeners();
  }

  updateContent(Message message) {
    for(Session session in _listSession) {
      if(session.sessionId == message.sessionId) {
        if(message.type == 0) {
          session.content = message.content;
        } else if(message.type == 2) {
          session.content = "语音";
        }
      }
    }
    notifyListeners();
  }

  clear() {
    _listSession.clear();
  }

  init() async{
    if(GlobalConfig.initSession == false) {
      GlobalConfig.initSession = true;
      _listSession.clear();
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
            sessionType: session.containsKey("sessionType") ? session['sessionType'] : null,
          );
          _listSession.add(s);
//          _mapSession[s.sessionId] = s;
        }

        notifyListeners();
      }
      socketManage.isOnline = true;
      socketManage.conn();
    }
  }

  clearUnreadSession(int sessionId) {
    for(Session session in _listSession) {
      if(session.sessionId == sessionId) {
        session.unreadnum = 0;
      }
    }
//    _mapSession[sessionId].unreadnum = 0;
  }

}
