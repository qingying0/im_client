import 'dart:math';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/msg/msg.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

class SessionProvider with ChangeNotifier {

  List<Session> _listSession = new List<Session>();
  Map<int ,Session> _mapSession = new Map();
  Map<int ,Session> _mapFriendIdSession = new Map();
  bool initdata = false;

  List get listSession => _listSession;
  Map get mapSession => _mapSession;

  getSessionIdByUserId(int id) {
    return _mapFriendIdSession[id].id;
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

  addUnReadNum(Message message) {
    _mapSession[message.sessionId].unreadnum++;

  }

  updateContent(Message message) {
    if(message.type == 0) {
      _mapSession[message.sessionId].content = message.content;
    }
  }

  clear() {
    _listSession.clear();
    _mapFriendIdSession.clear();
    _mapSession.clear();
  }

  init() async{
    if(GlobalConfig.initSession == false) {
      GlobalConfig.initSession = true;
      _listSession.clear();
      _mapFriendIdSession.clear();
      _mapSession.clear();
      print("init session");
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
            userId: session.containsKey("targetId") ? session['targetId'] : null,
            nickName: session.containsKey("nickname") ? session['nickname'] : null,
            content: session.containsKey("content") ? session['content'] : null,
            avatarUrl: null,
            updateTime: getTime(DateTime.parse(session['updateTime'])),
            unreadnum: session.containsKey("unreadNum") ? session['unreadNum'] : null,
          );
          _listSession.add(s);
          _mapSession[s.sessionId] = s;
          _mapFriendIdSession[s.userId] = s;
        }
      }
      notifyListeners();
    }
  }

  clearUnreadSession(int sessionId) {
    _mapSession[sessionId].unreadnum = 0;
  }
}
