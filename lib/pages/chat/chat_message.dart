import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/store/provider/voice_record_provider.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.message}) ;
  Message message;
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Store.value<UserInfoProvider>(context);
    return userInfoProvider.id == message.sendId ?
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
              child: Image.network(message.avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
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
              child: Image.network(message.avatarUrl, fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.1,),
            ),
          width: MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      )
    );
  }

  Container getContent(context) {
    if(message.type == 0) {
      return new Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: new Text(message.content),
        constraints: BoxConstraints(
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.6,
        ),
      );
    } else if (message.type == 1) {

    } else if(message.type == 2) {
      return new Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: new GestureDetector(
          onTap: () {
            Store.value<VoiceRecordProvider>(context).playVoice(message.content);
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
