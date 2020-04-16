
import 'dart:convert';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/model/Group.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class GroupProvider with ChangeNotifier {
  List<Group> _listGroup = new List<Group>();

  GroupProvider() {
    init();
  }

  init() async{
    print("init group");
    _listGroup.clear();
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
          "token": await sharedGetData("token"),
        });
    var response = await dio.get("http://" + GlobalConfig.address + "/group");
    print("response = " + response.toString());
    if(response.data['code'] == 200) {
      List groups = response.data['data'];
      for (Map group in groups) {
        _listGroup.add(new Group(
          id: group.containsKey("id") ? group['id'] : null,
          groupName: group.containsKey("groupName") ? group['groupName'] : null,
          avatarUrl: group.containsKey("avatarUrl") ? group['avatarUrl'] : null,
          description: group.containsKey("description") ? group['description'] : null,
          ownId: group.containsKey("ownId") ? group['ownId'] : null,
        ));
      }
    }
    notifyListeners();
  }

  Group getGroup(int id) {
    for(Group g in _listGroup) {
      if(g.id == id) {
        return g;
      }
    }
    return null;
  }

  List getGroups() {
    return _listGroup;
  }

  addGroup(group) {
    _listGroup.add(group);
    notifyListeners();
  }

}
