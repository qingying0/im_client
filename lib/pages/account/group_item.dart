import 'package:chat/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  GroupItem({@required this.groupname, this.avatarUrl, this.description});
  final String groupname;
  final String avatarUrl;
  final String description;
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
              child:  CircleAvatar(child: avatarUrl == null ?
              Text(groupname[0]) : Image.network(avatarUrl))  ,
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child:  Text(groupname, style: TextStyle(fontSize: 22, color: Colors.black),maxLines: 1,),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ;
            }
        ));
      },
    );

  }
}
