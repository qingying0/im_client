import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddGroup extends StatefulWidget {

  @override
  State createState() {
    return _AddGroup();
  }
}

class _AddGroup extends State<AddGroup> {

  Map<int, bool> userMap = new Map();
  List<Friend> userList;

  @override
  Widget build(BuildContext context) {
    userList = Store.value<FriendsProvider>(context).getFriends();
    return Scaffold(
        appBar: AppBar( //导航栏
          title: Text("添加群聊"),
          actions: <Widget>[ //导航栏右侧菜单
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  addGroup();
                }
            ),
          ],
        ),
        body: new ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemBuilder: (BuildContext context, int index) {
            Friend friend = userList[index];
            return CheckboxListTile(
              title: Text(friend.username),
              value: userMap.containsKey(friend.id),
              onChanged: (bool value) {
                setState(() {
                  if(value) {
                    userMap[friend.id] = value;
                  } else {
                    userMap.remove(friend.id);
                  }
                });
              },
            );
          },
          itemCount: userList.length,
        ),
    );
  }

  void addGroup() async{
    Dio dio = new Dio();
    List<int> addUserList = userMap.keys.toList();
    print(addUserList);
    dio.options = new Options(
        headers : {
        "token": await sharedGetData("token"),
    });
    var response = await dio.post(GlobalConfig.baseUrl + "/group");
    if(response.data['code'] == 200) {
        print(response.data['data']);
        int groupId = response.data['data']['id'];
        String groupName = response.data['data']['groupName'];
        for(int userId in addUserList) {
          FormData formData = new FormData.from({
            "userId": userId,
            "username": getUserName(userId),
            "groupId": groupId,
            "groupName": groupName
          });
          dio.post(GlobalConfig.baseUrl + "/group/add", data: formData);
        }
    }
  }

  String getUserName(int id) {
    for(Friend friend in userList) {
      if(friend.id == id) {
        return friend.username;
      }
    }
    return null;
  }
}

