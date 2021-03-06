import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/db/message_dao.dart';
import 'package:chat/socket/socket_manager.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/store/provider/voice_record_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  ChatPage({this.session}) ;
  Session session;

  @override
  State createState() {
    print("session = " + session.toString());
    return _ChatPageState(session: session);
  }
}

class _ChatPageState extends State<ChatPage>{

  _ChatPageState({this.session});
  Session session;

  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  bool _isRecord = false;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Store.connect<MessageProvider>(
      builder: (context, snapshot, child) {
        return new Scaffold(
            appBar: AppBar(
              title: Text(session.nickName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.more),
                    onPressed: () {
                      toInfo();
                    }
                ),
              ],
            ),
            body: Container(
              color: Colors.white10,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
//                        print("message in chatpage = " + snapshot.getMessageBySessionId(widget.sessionId)[index].toString());
                        return ChatMessage(message: snapshot.getMessageBySessionId(session.sessionId)[index]);
                      },
                      itemCount: snapshot.getMessageBySessionId(session.sessionId).length,
                    ),
                  ),
                ],
              ),
            ),
          bottomNavigationBar: new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        );
      }
    );
  }

  void _handleSubmitted(String text) async{
    _textController.clear();
    UserInfoProvider userInfoProvider = Store.value<UserInfoProvider>(context);
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
    "token": await sharedGetData("token"),
    });
    FormData formData = FormData.from({
      "sessionId": session.sessionId,
      "type": 0,
      "content": text,
      "targetId": session.targetId
    });
    var response;
    if(session.sessionType == 0) {
      response = await dio.post(GlobalConfig.baseUrl + "/message", data: formData);
    } else if(session.sessionType == 1) {
      response = await dio.post(GlobalConfig.baseUrl + "/message/groupMessage", data: formData);
    } else {
      return;
    }
    var data = response.data['data'];
    print("data = " + data.toString());
    if(response.data['code'] == 200) {
      Message message = new Message(
        id: data['id'],
        sendId: data['sendId'],
        sessionId: data['sessionId'],
        targetId: session.targetId,
        type: data['type'],
        createTime: DateTime.parse(data['createTime']),
        content: data['content'],
        status: data['status'],
        username: data['username'],
        avatarUrl: data['avatarUrl']
      );
      messageDao.insert(message);
      Store.value<MessageProvider>(context).addMessageBySessionId(message);
      Store.value<SessionProvider>(context).updateContent(message);
    }
    _isComposing = false;
  }

  Widget getRecordVoice() {
    VoiceRecordProvider voiceRecordProvider = Store.value<VoiceRecordProvider>(context);
    // TODO: implement build
    bool ifTap = voiceRecordProvider.ifTap;
    return new GestureDetector(
      onTapDown: (result) {
        voiceRecordProvider.beginRecord();
      },
      onTapUp: (result) {
        print("on tap up");
        voiceRecordProvider.stopRecord();
        new Future.delayed(const Duration(seconds: 1));
        Message message = new Message(
            sendId: Store.value<UserInfoProvider>(context).id,
            sessionId: session.sessionId,
            targetId: session.targetId,
            createTime: DateTime.now(),
            type: 2,
            status: 0,
            username: Store.value<UserInfoProvider>(context).username,
            avatarUrl: Store.value<UserInfoProvider>(context).avatarUrl,
        );
        voiceRecordProvider.setMessage(message);
      },
      onTapCancel: () {
        voiceRecordProvider.cancelRecord();
      },
      child: new Container(
        child: Center(child: Text("按住说话"),),
        width: MediaQuery.of(context).size.width,
        height: 40,
        color: ifTap ? Colors.grey[600] : Colors.grey[200],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          height: 60,
            child: new Row(
                children: <Widget> [
                  new Container(
                    child: new IconButton(
                        icon: new Icon(Icons.record_voice_over),
                        onPressed: () {
                          setState(() {
                              print("setState");
                              _isRecord = !_isRecord;
                          });
                    }),
                  ),
                  new Flexible(
                      child: getInputContainer(),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                            onPressed: _isComposing ?  () => _handleSubmitted(_textController.text) : null,
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                      icon: new Icon(Icons.image),
                      onPressed: () {

                      }
                    ),
                  )
                ]
            )
        )
      );
  }

  Widget getInputContainer() {
    if(_isRecord) {
      return getRecordVoice();
    } else {
      return new TextField(
        onChanged: (String text) {
          setState(() {
            print("setState");
            _isComposing = text.length > 0;
          });
        },
        controller: _textController,
        onSubmitted: _handleSubmitted,
        decoration: new InputDecoration.collapsed(hintText: '发送消息'),
      );
    }
  }

  void toInfo() {

  }
}

