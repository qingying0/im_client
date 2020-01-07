import 'package:chat/db/message_dao.dart';
import 'package:chat/socket/websocket.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/msg/message_msg.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'package:chat/store/msg/msg.dart';

class ChatPage extends StatefulWidget {
  ChatPage(int sessionId, String nickName, int userId) {
    this.sessionId = sessionId;
    this.nickName = nickName;
    this.userId = userId;
  }
  int sessionId;
  String nickName;
  int userId;

  @override
  State createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Store.connect<MessageProvider>(
      builder: (context, snapshot, child) {
        return new Scaffold(
            appBar: AppBar(
              title: Text(widget.nickName),
              centerTitle: true,
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
                        return ChatMessage(snapshot.getMessageBySessionId(widget.sessionId)[index], animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 700)),);
                      },
                      itemCount: snapshot.getMessageBySessionId(widget.sessionId).length,
                    ),
                  ),
                  Divider(height: 1.0),
                  Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildTextComposer(),
                  )
                ],
              ),
            )
        );
      }
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    UserInfoProvider userInfoProvider = Store.value<UserInfoProvider>(context);
    webSocket.sendMsg(new Msg(type: MsgType.SENDMESSAGE.index, data: MessageMsg(sendId: userInfoProvider.id, sessionId: widget.sessionId, type: 0, content: text, targetId: widget.userId).toJson()).toJson());
    _isComposing = false;
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
                children: <Widget> [
                  new Flexible(
                      child: new TextField(
                        onChanged: (String text) {
                          setState(() {
                            _isComposing = text.length > 0;
                          });
                        },
                        controller: _textController,
                             onSubmitted: _handleSubmitted,
                        decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                      )
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                            onPressed: _isComposing ?  () => _handleSubmitted(_textController.text) : null,
                    ),
                  )
                ]
            )
        )
    );
  }
}
