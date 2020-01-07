
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
        print("response = " + response.toString());
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

  List data = [
    
    {

      "id": "8fbf538ae273714fc51df3e845edb22b",

      "url_token": "yong-hu-6198445175",

      "name": "用户6198445175",

      "use_default_avatar": true,

      "avatar_url": "https://pic4.zhimg.com/da8e974dc_is.jpg",

      "avatar_url_template": "https://pic4.zhimg.com/da8e974dc_{size}.jpg",

      "is_org": false,

      "type": "people",

      "url": "https://www.zhihu.com/people/yong-hu-6198445175",

      "user_type": "people",

      "headline": "",

      "gender": -1,

      "is_advertiser": false,

      "vip_info": {"is_vip": false, "rename_days": "60"},

      "badge": [],

      "is_following": false,

      "is_followed": true,

      "follower_count": 0,

      "answer_count": 0,

      "articles_count": 0

    },

    {

      "id": "a91ae701e3a5907caa2e9b391aa2ffed",

      "url_token": "maybe-15-63",

      "name": "Maybe",

      "use_default_avatar": false,

      "avatar_url":

      "https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg",

      "avatar_url_template":

      "https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_{size}.jpg",

      "is_org": false,

      "type": "people",

      "url": "https://www.zhihu.com/people/maybe-15-63",

      "user_type": "people",

      "headline": "",

      "gender": -1,

      "is_advertiser": false,

      "vip_info": {"is_vip": false, "rename_days": "60"},

      "badge": [],

      "is_following": false,

      "is_followed": true,

      "follower_count": 0,

      "answer_count": 0,

      "articles_count": 0

    },
  {

  "id": "2149cbd6f1fbd070ff9045e648764ab6",

  "url_token": "ji-yi-85-34",

  "name": "记忆",

  "use_default_avatar": false,

  "avatar_url":

  "https://pic1.zhimg.com/v2-0aa271fdadb3130a549af500c4d4569a_is.jpg",

  "avatar_url_template":

  "https://pic1.zhimg.com/v2-0aa271fdadb3130a549af500c4d4569a_{size}.jpg",

  "is_org": false,

  "type": "people",

  "url": "https://www.zhihu.com/people/ji-yi-85-34",

  "user_type": "people",

  "headline": "",

  "gender": -1,

  "is_advertiser": false,

  "vip_info": {"is_vip": false, "rename_days": "60"},

  "badge": [],

  "is_following": false,

  "is_followed": true,

  "follower_count": 0,

  "answer_count": 0,

  "articles_count": 0

  },

  {

  "id": "04d44e85c074c4b22775375886576303",

  "url_token": "leyls-50",

  "name": "Leyls",

  "use_default_avatar": false,

  "avatar_url":

  "https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg",

  "avatar_url_template":

  "https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_{size}.jpg",

  "is_org": false,

  "type": "people",

  "url": "https://www.zhihu.com/people/leyls-50",

  "user_type": "people",

  "headline": "",

  "gender": -1,

  "is_advertiser": false,

  "vip_info": {"is_vip": false, "rename_days": "60"},

  "badge": [],

  "is_following": false,

  "is_followed": true,

  "follower_count": 0,

  "answer_count": 0,

  "articles_count": 0

  },

  {

  "id": "8fbf538ae273714fc51df3e845edb22b",

  "url_token": "yong-hu-6198445175",

  "name": "用户6198445175",

  "use_default_avatar": true,

  "avatar_url": "https://pic4.zhimg.com/da8e974dc_is.jpg",

  "avatar_url_template": "https://pic4.zhimg.com/da8e974dc_{size}.jpg",

  "is_org": false,

  "type": "people",

  "url": "https://www.zhihu.com/people/yong-hu-6198445175",

  "user_type": "people",

  "headline": "",

  "gender": -1,

  "is_advertiser": false,

  "vip_info": {"is_vip": false, "rename_days": "60"},

  "badge": [],

  "is_following": false,

  "is_followed": true,

  "follower_count": 0,

  "answer_count": 0,

  "articles_count": 0

  },

  {

  "id": "a91ae701e3a5907caa2e9b391aa2ffed",

  "url_token": "maybe-15-63",

  "name": "Maybe",

  "use_default_avatar": false,

  "avatar_url":

  "https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg",

  "avatar_url_template":

  "https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_{size}.jpg",

  "is_org": false,

  "type": "people",

  "url": "https://www.zhihu.com/people/maybe-15-63",

  "user_type": "people",

  "headline": "",

  "gender": -1,

  "is_advertiser": false,

  "vip_info": {"is_vip": false, "rename_days": "60"},

  "badge": [],

  "is_following": false,

  "is_followed": true,

  "follower_count": 0,

  "answer_count": 0,

  "articles_count": 0

  },
  ];
}
