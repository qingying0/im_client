import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/user_info.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/user_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/store/provider/voice_record_provider.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(Message message) {
    this.messageId = message.id;
    this.sendId = message.sendId;
    this.sessionId = message.sessionId;
    this.type = message.type;
    this.createTime = message.createTime;
    this.content = message.content;
    this.status = message.status;
    this.username = message.username;
    this.avatarUrl = message.avatarUrl;
  }
  int messageId;
  int sendId;
  int sessionId;
  int type;
  DateTime createTime;
  String content;
  String username;
  String avatarUrl;
  int status;
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Store.value<UserInfoProvider>(context);
    return userInfoProvider.id == this.sendId ?
    getLeftContainer(context) : getRightContainer(context);
  }

  Container getLeftContainer(context) {
    return new Container(
      margin: EdgeInsets.only(top: 20),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start ,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            child: ClipOval(
              child: Image.network(avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
            ),
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          getContent(context),
        ],
      ),
    );
  }

  Container getRightContainer(context) {
    return new Container(
        margin: EdgeInsets.only(top: 20),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end ,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: getContent(context),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          Container(
          margin: EdgeInsets.only(right: 10, top: 10),
            child: ClipOval(
              child: Image.network(avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
            ),
          width: MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      )
    );
  }

  Container getContent(context) {
    if(type == 0) {
      return new Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: new Text(content),
        constraints: BoxConstraints(
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.6,
        ),
      );
    } else if (type == 1) {

    } else if(type == 2) {
      return new Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: new GestureDetector(
          onTap: () {
            Store.value<VoiceRecordProvider>(context).playVoice(content);
          },
          child: new Text("点击播放"),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.6,
        ),
      );
    }
  }
}
