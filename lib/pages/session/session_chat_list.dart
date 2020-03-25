import 'package:chat/db/message_dao.dart';
import 'package:chat/pages/login/login.dart';
import 'package:chat/pages/user/user_data.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/msg/enums.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/socket/socket_manager.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:flutter/material.dart';
import 'session_chat.dart';

class SessionChatList extends StatefulWidget {


  @override
  State createState() {
    return new _SessionChatList();
  }
}

class _SessionChatList extends State<SessionChatList> {


  Widget _drawerOption(Icon icon, String name) {

    return new Container(
      padding: EdgeInsets.only(top: 22),
      child: new Row(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(right: 28,),
            child: icon,
          ),
          new Text(name)
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Drawer drawer = new Drawer(
      child: new ListView(
        children: <Widget>[
          Store.connect<UserInfoProvider>(
              builder: (context, snapshot, child) {
                return new DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: new Stack(children: <Widget>[ /* 用stack来放背景图片 */
                    new Align(/* 先放置对齐 */
                      alignment: FractionalOffset.bottomLeft,
                      child: Container(
                        height: 70.0,
                        margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(child:
                                ClipOval(
                                child:Image.network(snapshot.avatarUrl))
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 6.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                                mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                                children: <Widget>[
                                  new Text('${snapshot.username}', style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,),),
                                  new Text(snapshot.phone == null ? '' : '${snapshot.phone}', style: new TextStyle(
                                    fontSize: 14.0, ),),
                                ],
                              ),
                            ),
                          ],),
                      ),
                    ),
                  ]),);
              }
          ),
          new FlatButton(
            child: _drawerOption(new Icon(Icons.account_circle), "个人资料"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return new UserData();
                  }
              ));
            },
          ),
          // new FlatButton(
          //   child: _drawerOption(new Icon(Icons.settings), "应用设置"),
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) {
          //           return ;
          //         }
          //     ));
          //   },
          // ),
          new FlatButton(
            child: _drawerOption(new Icon(Icons.settings), "退出登录"),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: Text("消息", textAlign: TextAlign.center,),
      ),
      drawer: drawer,
      body:  Store.connect<SessionProvider>(
        builder: (context, snapshot, child) {
          return snapshot.listSession == null ? new CircularProgressIndicator() :new Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (BuildContext context, int index) {
                    List<Session> listSession = snapshot.listSession;
                    return SessionChat(listSession[index]);
                  },
                  itemCount: snapshot.listSession.length,
                ),
              ),
            ],
          );
        }
      )
    );
  }

  logout() async {
    var id = await sharedGetData("id");
    await sharedDeleteData("id");
    await sharedDeleteData("phone");
    await sharedDeleteData("phone");
    await sharedDeleteData("token");
    await sharedDeleteData("avatarUrl");
    await sharedDeleteData("description");
    await sharedDeleteData("pushId");
    socketManage.isOnline = false;
    socketManage.sendOffLine();
    Store.value<SessionProvider>(context).clear();
    Store.value<MessageProvider>(context).clear();
    messageDao.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return Login();
        }
    ));

  }
}
