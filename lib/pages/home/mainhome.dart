import 'package:chat/pages/account/contacts_list.dart';
import 'package:chat/pages/login/login.dart';
import 'package:chat/pages/session/session_chat.dart';
import 'package:chat/pages/session/session_chat_list.dart';
import 'package:chat/socket/websocket.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/msg/msg.dart';
import 'package:chat/store/msg/online_msg.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/user_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/shared_utils.dart';

class MainHome extends StatefulWidget{

  @override
  State createState() {
    return new _MainHome();
  }
}

class _MainHome extends State<MainHome> {



  int _currentIndex = 0;
  List _pageList = [
    SessionChatList(),
    ContactsList()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store.value<FriendsProvider>(context).init();
    Store.value<SessionProvider>(context).init();
    webSocket.isOnline = true;
    webSocket.setContext(context);
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.message),
            title: new Text("消息"),
            backgroundColor: _currentIndex == 0 ? Theme.of(context).primaryColor : Colors.black12,
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.account_box),
            title: new Text("联系人"),
            backgroundColor: _currentIndex == 1 ? Theme.of(context).primaryColor : Colors.black12,
          )
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          _currentIndex = index;
          setState(() {
          });
        },

      ),
      body: _pageList[_currentIndex],
    );
  }
}

