import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/user/personal.dart';
import 'package:chat/store/model/user_info.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddFriend extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<List> result = searchUser(query, context);
    return new FutureBuilder(
      future: result,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<UserInfo> listUserInfo = snapshot.data;
          print(listUserInfo.length);
          return new ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              return UserItem(userInfo: listUserInfo[index]);
            },
            itemCount: listUserInfo.length,
          );
        }
        return Center(child: Text("未找到对应用户"));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return new Container();
  }

  Future<List> searchUser(String search, BuildContext context) async {
    List<UserInfo> listUserInfo = new List();
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
          "token": await sharedGetData("token"),
      });
    var response = await dio.get(GlobalConfig.baseUrl + "/user/search?search=$search");
    var data = response.data['data'];
    if(response.data['code'] == 200) {
      List listUser = response.data['data'];
      for(Map map in listUser) {
        UserInfo userInfo = new UserInfo(
          id: map.containsKey("id") ? map['id'] : null,
          username: map.containsKey("username") ? map['username'] : null,
          avatarUrl: map.containsKey("avatarUrl") ? map['avatarUrl'] : null,
          phone: map.containsKey("phone") ? map['phone'] : null,
          description: map.containsKey("description") ? map['description'] : null,
        );
        listUserInfo.add(userInfo);
      }
    } else {
      Toast.toast(context, msg: "查找失败:" + response.data['message']);
    }
    return listUserInfo;
  }
}

class UserItem extends StatelessWidget {
  UserItem({this.userInfo});
  UserInfo userInfo;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      height: 60,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: ClipOval(
              child: Image.network(userInfo.avatarUrl, fit: BoxFit.fill, height: 45,),
            ),
            height: 45,
            width: 45,
            margin: EdgeInsets.only(right: 10),
          ),
          new FlatButton(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: Text(userInfo.username, style: TextStyle(fontSize: 20, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Personal(
                      userInfo: userInfo
                    );
                  }
              ));
            },
          ),
        ],
      ),
    );
  }
}
