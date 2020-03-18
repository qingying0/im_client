
import 'package:chat/db/message_dao.dart';
import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:flutter/material.dart';

class SessionChat extends ListTile {
  SessionChat(int  sessionId) {
    this.sessionId = sessionId;
  }
  int sessionId;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))
      ),
      child: Store.connect<SessionProvider>(
        builder: (context, snapshot, child) {
          int id = snapshot.getSession(this.sessionId).targetId;
          Friend f = Store.value<FriendsProvider>(context).getFriend(id);
          return FlatButton(
            child: new Container(
              height: 80,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child:  ClipOval(
                      child: Image.network(f.avatarUrl, fit: BoxFit.fill, height: 45,),
                    ),
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(right: 10),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          child: Text(snapshot.getSession(this.sessionId).nickName, style: TextStyle(fontSize: 20, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: new Text(snapshot.getSession(this.sessionId).content, style: TextStyle(fontSize: 16, color: Color(0xFFa9a9a9)), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          child: Text(snapshot.getSession(this.sessionId).updateTime, style: TextStyle(fontSize: 16, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),

                        Container(
                          width: 20,
                          child: new CircleAvatar(
                            backgroundColor: snapshot.getSession(this.sessionId).unreadnum == 0 ? Colors.white :  Colors.red,
                            child: new Text(snapshot.getSession(this.sessionId).unreadnum.toString(), style: TextStyle(color: Colors.white),),
                            radius: 10,),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Store.value<MessageProvider>(context).clearBySession(sessionId);
              Store.value<SessionProvider>(context).clearUnreadSession(sessionId);
              messageDao.getMessageBySessionId(sessionId).then((listMessage) {
                listMessage.forEach((item) {
                  Message message = new Message(
                    id: item['id'],
                    sendId: item['send_id'],
                    sessionId: item['session_id'],
                    type: item['type'],
                    createTime: DateTime.fromMicrosecondsSinceEpoch(item['create_time']) ,
                    content: item['content'],
                    status: item['status'],
                    avatarUrl: item['avatar_url'],
                    username: item['username']
                  );
                  Store.value<MessageProvider>(context).addMessageBySessionId(message);
                });
              });
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(snapshot.getSession(this.sessionId).sessionId, snapshot.getSession(this.sessionId).nickName, snapshot.getSession(this.sessionId).targetId);
                  }
              ));
            },
          ) ;
        }
      ) ,
    );
  }

}
