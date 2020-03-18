
import 'dart:convert';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class FriendsProvider with ChangeNotifier {
  List<Friend> _listFriend = new List<Friend>();

  init() async{
    if(GlobalConfig.initFriend == false) {
      GlobalConfig.initFriend = true;
      _listFriend.clear();
      Dio dio = new Dio();
      dio.options = new Options(
        headers : {
          "token": await sharedGetData("token"),
        });
      var response = await dio.get("http://" + GlobalConfig.address + "/friend");
      if(response.data['code'] == 200) {
        List friends = response.data['data'];
        for (Map friend in friends) {
          _listFriend.add(new Friend(
            id: friend.containsKey("id") ? friend['id'] : null,
            username: friend.containsKey("username") ? friend['username'] : null,
            avatarUrl: friend.containsKey("avatarUrl") ? friend['avatarUrl'] : null,
            description: friend.containsKey("description") ? friend['description'] : null,
            sex: friend.containsKey("sex") ? friend['sex'] : null,
            status: friend.containsKey("status") ? friend['status'] : null,
          ));
        }
      }
      notifyListeners();
    }
  }

  Friend getFriend(int id) {
    for(Friend f in listFriend) {
      if(f.id == id) {
        return f;
      }
    }
    return null;
  }

  getFriends() {
    return _listFriend;
  }

  List get listFriend =>_listFriend;

  addFriend(friend) {
    _listFriend.add(friend);
    notifyListeners();
  }

  removeFriend(friend) {
    _listFriend.remove(friend);
    notifyListeners();
  }
}
