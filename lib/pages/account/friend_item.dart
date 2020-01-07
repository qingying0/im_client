import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/pages/session/session_chat.dart';
import 'package:chat/pages/user/person.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:flutter/material.dart';

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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              var sessionId = Store.value<SessionProvider>(context).getSessionIdByUserId(id);
              return ChatPage(sessionId, this.username, this.id);
            }
        ));
      },
    );
  }
}
