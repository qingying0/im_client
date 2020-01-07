import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/utils/http_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RequestPage extends StatefulWidget {
  RequestPage({this.userId});
  final int userId;

  @override
  State<StatefulWidget> createState() {
    return new _RequestPage();
  }
}

class _RequestPage extends State<RequestPage> {

  var _contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
                title: new Container(
                  child: new Row(
                    children: <Widget>[
                      new FlatButton.icon(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: new Icon(Icons.clear, color: Colors.white70),
                        label: new Text(""),
                      ),
                      new Expanded(
                          child: new Container(
                            child: new Text("好友请求"),
                          )
                      ),
                      new FlatButton(
                          onPressed: (){
                              friendRequest();
                          },
                          child: new Text("发送", style: new TextStyle(color: Colors.black54))
                      )
                    ],
                  ),
                )
            ),
            body: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new TextField(
                      controller: _contentTextController,
                      decoration: new InputDecoration(
                          hintText: "请求描述",
                          hintStyle: new TextStyle(color: Colors.black54)
                      ),
                    ),
                    margin: const EdgeInsets.all(16.0),
                  ),

                ],
              ),
            )
        )
    );
  }

  friendRequest() async{
    Dio dio = new Dio();
    dio.options = HttpUtils.getOption(context);
    var userId = widget.userId;
    var content = _contentTextController.text;
    var response = await dio.post(
      GlobalConfig.baseUrl + "/request?targetId=$userId&content=$content",
      // options: HttpUtils.getOption(context) 
      );
    if(response.data['code'] == 200) {
      Toast.toast(context, msg: "添加好于请求已发送:");
    } else {
      Toast.toast(context, msg: response.data['message']);
    }
  }

}