import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/user_info.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/user_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(Message message,{@required this.animationController}) {
    this.messageId = message.id;
    this.sendId = message.sendId;
    this.sessionId = message.sessionId;
    this.type = message.type;
    this.createTime = message.createTime;
    this.content = message.content;
    this.status = message.status;
  }
  int messageId;
  int sendId;
  int sessionId;
  int type;
  DateTime createTime;
  String content;
  int status;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Store.value<UserInfoProvider>(context);
    return userInfoProvider.id == this.sendId ?
    new Container(
      margin: EdgeInsets.only(top: 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start ,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            child: ClipOval(
              child: userInfoProvider.avatarUrl == null ?
              Image.network("https://pic4.zhimg.com/da8e974dc_is.jpg", fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,) : Image.network(userInfoProvider.avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
            ),
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: new Text(content),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
        ],
      ),
    ) : new Row(
      mainAxisAlignment: MainAxisAlignment.end ,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: new Text(content),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 10, top: 10),
          child: ClipOval(
            child: Store.value<FriendsProvider>(context).getFriend(sendId).avatarUrl == null ?
            //                  Image.network("http://b-ssl.duitang.com/uploads/item/201410/09/20141009224754_AswrQ.jpeg")
            Image.network("https://pic4.zhimg.com/da8e974dc_is.jpg", fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,) : Image.network(Store.value<FriendsProvider>(context).getFriend(sendId).avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
          ),
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      ],
    );


  }
}
