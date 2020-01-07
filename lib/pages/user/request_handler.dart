
import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/socket/websocket.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/Request.dart';
import 'package:chat/store/provider/request_provider.dart';
import 'package:chat/utils/http_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestHandler extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FriendHandler();
  }

}


class _FriendHandler extends State<RequestHandler> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(
            title: Text("好友请求"),
            centerTitle: true,
          ),
          body: Store.connect<RequestProvider>(
            builder: (context, snapshot, child) {
              return new ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (BuildContext context, int index) {
                  List<Request> listRequest = snapshot.getRequests();
                  return RequestItem(listRequest[index]);
                },
                itemCount: snapshot.getRequests().length,
              );
            }
          )
        );
  }
}


class RequestItem extends StatelessWidget {
  RequestItem(Request request) {
    this.id = request.id;
    this.username = request.username;
    this.content = request.content;
    this.type = request.type;
    this.status = request.status;
    this.avatarUrl = request.avatarUrl;

  }
  int id;
  String username;
  String content;
  String avatarUrl;
  int type;
  int status;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return new Container(
      height: 60,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: ClipOval(
              child: avatarUrl == null ?
              Image.asset("images/2.jpg", fit: BoxFit.fill, height: 45,) : Image.network(avatarUrl, fit: BoxFit.fill, height: 45,),
            ),
            height: 45,
            width: 45,
            margin: EdgeInsets.only(right: 10),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: Text(username, style: TextStyle(fontSize: 20, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: new Text(content, style: TextStyle(fontSize: 16, color: Color(0xFFa9a9a9)), maxLines: 1, overflow: TextOverflow.ellipsis,),
                )
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: status == 0 ? new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                  child: new Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black12,
                    child: Text("同意添加", style: TextStyle(fontSize: 16, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  onPressed: () {
                    updateRequest(ReuqestEnum.SUCCESS.index);
                  }
                ),
                new FlatButton(
                  child: new Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black12,
                    child: Text("忽略", style: TextStyle(fontSize: 16, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  onPressed: () {
                    updateRequest(ReuqestEnum.FAILD.index);
                  },
                ),
              ],
            ) : new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(status == 1 ? "添加成功" : "已经忽略", style: TextStyle(fontSize: 16, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
              )
          ),
        ],
      ),
    );
  }

  updateRequest(int status) async {
    Dio dio = new Dio();
    dio.options = HttpUtils.getOption(context);
    var response = await dio.put(
      GlobalConfig.baseUrl + "/request?requestId=$id&status=$status",
      );
    if(response.data['code'] == 200) {
      var data = response.data['data'];
      Store.value<RequestProvider>(context).updateRequest(data['id'], data['status']);
    } else {
      Toast.toast(context, msg: "发生错误:" + response.data['message']);
    }
  }
  


}