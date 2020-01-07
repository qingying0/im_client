import 'package:chat/pages/account/group_item.dart';
import 'package:chat/pages/session/session_chat.dart';
import 'package:flutter/material.dart';

import 'friend_item.dart';


class GroupList extends StatefulWidget {

  @override
  State createState() {
    return new _GroupList();
  }
}

class _GroupList extends State<GroupList> {
  final List<GroupItem> _groups = <GroupItem>[
    new GroupItem(groupname: "ccc", avatarUrl: null, description: "bbb",),
    new GroupItem(groupname: "ccc", avatarUrl: null, description: "bbb",),
    new GroupItem(groupname: "ccc", avatarUrl: null, description: "bbb",),
    new GroupItem(groupname: "ccc", avatarUrl: null, description: "bbb",),

  ];

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (_, int index)=> _groups[index],
            itemCount: _groups.length,
          ),
        ),
      ],
    );
  }
}
