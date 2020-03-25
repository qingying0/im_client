import 'package:chat/db/message_dao.dart';
import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/Group.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/provider/group_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:flutter/material.dart';


class GroupList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Store.connect<GroupProvider>(
        builder: (context, snapshot, child) {
          return new Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return GroupItem(snapshot.getGroups()[index]);
                    },
                    itemCount: snapshot.getGroups().length
                ),
              ),
            ],
          );
        });
  }
}

class GroupItem extends StatelessWidget {
  GroupItem(Group group) {
    this.id = group.id;
    this.groupName = group.groupName;
    this.avatarUrl = group.avatarUrl;
    this.description = group.description;
  }
  int id;
  String groupName;
  String avatarUrl;
  String description;
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Container(
        height: 52,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child:  CircleAvatar(child: Image.network(avatarUrl))  ,
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child:  Text(groupName, style: TextStyle(fontSize: 22, color: Colors.black),maxLines: 1,),
            ),
          ],
        ),
      ),
      onPressed: () {
        Session session = Store.value<SessionProvider>(context).getSessionByGroupId(id);
        Store.value<MessageProvider>(context).clearBySession(session.sessionId);
        Store.value<SessionProvider>(context).clearUnreadSession(session.sessionId);
        messageDao.getMessageBySessionId(session.sessionId).then((listMessage) {
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
              return ChatPage(session: session,);
            }
        ));
      },
    );
  }
}
