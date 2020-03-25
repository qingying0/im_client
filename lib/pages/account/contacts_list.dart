import 'package:chat/pages/account/friend_list.dart';
import 'package:chat/pages/account/group_list.dart';
import 'package:chat/pages/user/request_handler.dart';
import 'package:flutter/material.dart';

import 'add_friend.dart';
import 'add_group.dart';

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
              new PopupMenuButton(
                onSelected: (String value){
                    print(value);
                    if(value == "1") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return new AddGroup();
                          }
                      ));
                    } else if(value == "2") {
                      print("true");
                      showSearch(context: context, delegate: new AddFriend());
                    } else if(value == "3") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return new RequestHandler();
                          }
                      ));
                    }
                },
                itemBuilder: (BuildContext context) =><PopupMenuItem<String>>[
                  new PopupMenuItem(
                      value:"1",
                      child: new Text("创建群组")
                  ),
                  new PopupMenuItem(
                      value: "2",
                      child: new Text("添加好友")
                  ),
                  new PopupMenuItem(
                      value: "3",
                      child: new Text("好友请求")
                  ),
                ]
              )
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              new FriendList(),
              new GroupList()
            ],
          ),
        )
    );
  }
}

