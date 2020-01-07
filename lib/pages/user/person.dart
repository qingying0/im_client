import 'package:chat/pages/user/request_page.dart';
import 'package:flutter/material.dart';

class Personal extends StatelessWidget {

  Personal({@required this.userId, @required this.username, @required this.avatarUrl, @required this.description, @required this.friend});
  final int userId;
  final String avatarUrl;
  final String username;
  final String description;
  final bool friend;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 30),
                child:BackButton(),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20.0),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 12.0, right: 15.0),
                      child: avatarUrl == null ?
                        Image.asset("images/2.jpg")   :
                        Image.network(avatarUrl),
                      width: 70,
                      height: 70,
                    ),
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("用户名：" + username, style: TextStyle(fontSize: 20),),
                          new Text("签名:" + username),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              friend ? isfriend() : notFriend(),
            ],

      ),
        ],
      )
    );
  }

  isfriend() {
    return new FlatButton(
          child: new Container(
            margin: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            decoration: new BoxDecoration(
                color: Colors.blue
            ),
            child: new Center(
              child: new Text("发送消息",
                  style: new TextStyle(
                    color: const Color(0xff000000),
                  ))),
          ),
          onPressed: () {
          },
        );
  }

  notFriend() {
    return new FlatButton(
          child: new Container(
            margin: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            decoration: new BoxDecoration(
                color: Colors.blue
            ),
            child: new Center(
              child: new Text("添加好友",
                  style: new TextStyle(
                    color: const Color(0xff000000),
                  ))),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return RequestPage(userId: userId);
                }
            ));
          },
        );
  }


}
