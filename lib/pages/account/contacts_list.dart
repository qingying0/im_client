import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/account/friend_list.dart';
import 'package:chat/pages/account/group_list.dart';
import 'package:chat/pages/user/request_handler.dart';
import 'package:chat/socket/websocket.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/Request.dart';
import 'package:chat/store/msg/msg.dart';
import 'package:chat/store/msg/online_msg.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/request_provider.dart';
import 'package:chat/utils/http_utils.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'add_friend.dart';
import 'friend_item.dart';

class ContactsList extends StatefulWidget {

  @override
  State createState() {
    return new _ContactsList();
  }
}

class _ContactsList extends State<ContactsList> {


  @override
  Widget build(BuildContext context) {
    
    return new DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("联系人", textAlign: TextAlign.center,),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "好友",),
                Tab(text: "群组",)
              ],
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  getRequest();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return new RequestHandler();
                      }
                  ));
                },
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              new FriendList(),
              new GroupList()
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AddFriend();
              },
              ).then((val) {
                
              });
            },
            child: new Icon(Icons.group_add),
          ),
        )
    );
  }

  getRequest() async{
    Dio dio = new Dio();
    dio.options = HttpUtils.getOption(context);
    var response = await dio.get(
      GlobalConfig.baseUrl + "/request",
      );
    if(response.data['code'] == 200) {
      var listRequest = response.data['data'];
      Store.value<RequestProvider>(context).clear();
      for (var request in listRequest) {
        Store.value<RequestProvider>(context).addRequest(new Request(id: request['id'], username: request['username'], content: request['content'], type: request['type'], status: request['status'], avatarUrl: request['avatarUrl']));
      }
      // 
    } else {
      Toast.toast(context, msg: "发生错误:" + response.data['message']);
    }
  }
}

