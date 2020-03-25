import 'dart:math';

import 'package:chat/store/model/message.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class MessageProvider with ChangeNotifier {

  Map<int, List<Message>> _mapSessionIdMessage = new Map();

  Map get mapSessionIdMessage => _mapSessionIdMessage;

  clear() {
    _mapSessionIdMessage.clear();
  }

  addMessageBySessionId(Message message) {
    if(!_mapSessionIdMessage.containsKey(message.sessionId)) {
      _mapSessionIdMessage[message.sessionId] = new List();
    }
    _mapSessionIdMessage[message.sessionId].insert(0, message);
    notifyListeners();
  }

  getMessageBySessionId(int sessionId) {
    if(!_mapSessionIdMessage.containsKey(sessionId)) {
      _mapSessionIdMessage[sessionId] = new List();
    }
    return _mapSessionIdMessage[sessionId];
  }

  clearBySession(int sessionId) {
    if(_mapSessionIdMessage[sessionId] != null) {
      _mapSessionIdMessage[sessionId].clear();
    }
  }

}
