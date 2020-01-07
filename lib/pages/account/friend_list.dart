import 'package:chat/store/index.dart';
import 'package:chat/store/model/friend.dart';
import 'package:chat/store/model/session.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:flutter/material.dart';

import 'friend_item.dart';


class FriendList extends StatefulWidget {

  @override
  State createState() {
    return new _FriendList();
  }
}

class _FriendList extends State<FriendList> {

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
    // return new Column(
    //   children: <Widget>[
    //     Flexible(
    //       child: ListView.builder(
    //         padding: EdgeInsets.only(top: 10),
    //         itemBuilder: (BuildContext context, int index) {
    //           return FriendItem(listFriend[index]);
    //         },
    //         itemCount: listFriend.length
    //       ),
    //     ),
    //   ],

    // );
  }
}
