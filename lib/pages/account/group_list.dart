import 'package:chat/pages/account/group_item.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/provider/group_provider.dart';
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
