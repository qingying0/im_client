import 'package:chat/pages/account/contacts_list.dart';
import 'package:chat/pages/session/session_chat_list.dart';
import 'package:chat/socket/socket_manager.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/group_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/store/provider/voice_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    socketManage.isOnline = true;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=>UserInfoProvider(),),
        ChangeNotifierProvider(builder: (_)=>FriendsProvider(),),
        ChangeNotifierProvider(builder: (_)=>SessionProvider(),),
        ChangeNotifierProvider(builder: (_)=>MessageProvider(),),
        ChangeNotifierProvider(builder: (_)=>VoiceRecordProvider(),),
        ChangeNotifierProvider(builder: (_)=>GroupProvider(),),
      ],
      child: MaterialApp(
        title: "im",
        home: Builder(
          builder: (context) {
            socketManage.setContext(context);
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
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              body: _pageList[_currentIndex],
            );
          }
        ),
      ),
    );
  }
}

