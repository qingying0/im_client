import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/home/mainhome.dart';
import 'package:chat/pages/login/login.dart';
import 'package:chat/socket/websocket.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/msg/msg.dart';
import 'package:chat/store/msg/online_msg.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/shared_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
//  runApp(MyHome());
  var id = await sharedGetData("id");
  
  if(id == null) {
    runApp(MyApp());
  } else {
    runApp(MyHome(id: id,));
  }
}


class MyApp extends StatelessWidget {

  final ThemeData defaultTheme = new ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.grey[100],
  );

  @override
  Widget build(BuildContext context) {
    webSocket.conn();
    GlobalConfig.setInitFriend();
    GlobalConfig.setInitSession();
    return Store.init(
      context: context,
      child: MaterialApp(
        title: "aqachat",
        home: Builder(
          builder: (context) {
            Store.widgetCtx = context;
            return Login();
          }
        ),
      )
    );
  }
}

class MyHome extends StatelessWidget {

  MyHome({this.id});
  int id;

  @override
  Widget build(BuildContext context) {
    webSocket.conn();
    print("myhome rebuild");
    webSocket.sendMsg(new Msg(type: MsgType.ONLINE.index, data: OnlineMsg(type: OnlineEnum.ONLINE.index, userId: id).toJson()).toJson());
    GlobalConfig.setInitFriend();
    GlobalConfig.setInitSession();
    return  Store.init(
      context: context,
      child: MaterialApp(
        title: "aqachat",
        home: Builder(
            builder: (context) {
              Store.value<FriendsProvider>(context).init();
              Store.widgetCtx = context;
              return MainHome();
            }
        ),
      )
    );
  }

}



