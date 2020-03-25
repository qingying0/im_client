import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/user/request_page.dart';
import 'package:chat/store/model/user_info.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  Personal({this.userInfo});
  UserInfo userInfo;

  @override
  State createState() {
    return _Personal(userInfo: userInfo);
  }

}

class _Personal extends State<Personal> {

  _Personal({this.userInfo});
  UserInfo userInfo;
  bool friend = false;
  BuildContext context;


  @override
  void initState() {
    userInfo.description = userInfo.description != null ? userInfo.description : " ";
    initFriend();
  }

  void initFriend() async{
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
    "token": await sharedGetData("token"),
    });
    int id = userInfo.id;
    var response = await dio.get(GlobalConfig.baseUrl + "/friend/isFriend?userId=$id");
    if(response.data['code'] == 200) {
      print(response.data['data']);
      setState(() {
        friend = response.data['data'];
      });

    }
  }

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
                      child: Image.network(userInfo.avatarUrl),
                      width: 70,
                      height: 70,
                    ),
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("用户名：" + userInfo.username, style: TextStyle(fontSize: 20),),
                          new Text("签名:" + userInfo.description),
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
            margin: EdgeInsets.only(top: 30, left: 40, right: 40),
            height: 60,
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
            margin: EdgeInsets.only(top: 30, left: 40, right: 40),
            height: 60,
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
                  return RequestPage(userId: userInfo.id);
                }
            ));
          },
        );
  }


}
