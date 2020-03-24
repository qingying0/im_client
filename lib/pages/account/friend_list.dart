import 'package:chat/db/message_dao.dart';
import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:flutter/material.dart';


class FriendList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Store.connect<FriendsProvider>(
        builder: (context, snapshot, child) {
          return new Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (BuildContext context, int index) {

                      return FriendItem(snapshot.getFriends()[index]);
                    },
                    itemCount: snapshot.getFriends().length
                ),
              ),
            ],
          );
        });
  }
}

class FriendItem extends StatelessWidget {
  FriendItem(Friend friend) {
    this.id = friend.id;
    this.username = friend.username;
    this.avatarUrl = friend.avatarUrl;
    this.description = friend.description;
    this.status = friend.status;
  }
  int id;
  String username;
  String avatarUrl;
  String description;
  int status;
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Container(
        height: 52,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 10,top: 5),
              child:  ClipOval(
                child: avatarUrl == null ?
                Text(username[0], style: TextStyle(fontSize: 30),) : Image.network(avatarUrl, fit: BoxFit.fill, height: 60,),
              ),
              height: 35,
              width: 35,
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: Text(username, style: TextStyle(fontSize: 18, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                new Row(
                  children: <Widget>[
                    this.status == 0 ? new Text( "[在线]", style: TextStyle(fontSize: 14, color: Colors.blueAccent), maxLines: 1, overflow: TextOverflow.ellipsis,)
                        : new Text( "[离线]", style: TextStyle(fontSize: 14, color: Color(0xFFa9a9a9)), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: new Text( this.description == null ? "" : description, style: TextStyle(fontSize: 14, color: Color(0xFFa9a9a9)), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onPressed: () {
        var sessionId = Store.value<SessionProvider>(context).getSessionIdByUserId(id);
        Store.value<MessageProvider>(context).clearBySession(sessionId);
        Store.value<SessionProvider>(context).clearUnreadSession(sessionId);
        messageDao.getMessageBySessionId(sessionId).then((listMessage) {
          listMessage.forEach((item) {
            Message message = new Message(
                id: item['id'],
                sendId: item['send_id'],
                sessionId: item['session_id'],
                type: item['type'],
                createTime: DateTime.fromMicrosecondsSinceEpoch(item['create_time']),
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
              return ChatPage(sessionId, this.username, this.id);
            }
        ));
      },
    );
  }
}

