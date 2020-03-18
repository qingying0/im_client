import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/user/person.dart';
import 'package:chat/utils/http_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddFriend extends StatefulWidget {


  @override
  State createState() {
    return new _AddFriend();
  }
}

class _AddFriend extends State<AddFriend> {

  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("添加好友"),
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.symmetric(horizontal: 23.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                  child: new TextField(
                    controller: _searchController,
                    decoration: new InputDecoration.collapsed(hintText: "点击此处输入手机号码"),
                  )
              ),
              new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    _handlerFind();
                  }
              )
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 18.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new RaisedButton(
                elevation: 0,
                onPressed: () {
                  Navigator.pop(context);
                },
                colorBrightness: Brightness.dark,
                child: const Text("取消"),
              ),
            ],

          ),
        )
      ],
    );
  }

  _handlerFind() async{
    var search = _searchController.text;
    Dio dio = new Dio();
    var response = await dio.get(
      GlobalConfig.baseUrl + "/user/search_by_phone?phone=$search",
      options: HttpUtils.getOption(context) );
    var data = response.data['data'];
    if(response.data['code'] == 200) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return Personal(userId: data['id'], username: data['username'], description: data['description'], avatarUrl: data['avatarUrl'], friend: data['friend'],);
        }
      ));
    } else {
      Toast.toast(context, msg: "查找失败:" + response.data['message']);
    }
  }
}
