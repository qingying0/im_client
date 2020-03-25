
import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/model/Request.dart';
import 'package:chat/utils/http_utils.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestHandler extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RequestHandler();
  }
}


class _RequestHandler extends State<RequestHandler> {

  List<Request> listRequest = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequest();
  }

  void initRequest() async{
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
    "token": await sharedGetData("token"),
    });
    var response = await dio.get(GlobalConfig.baseUrl + "/request");
    if(response.data['code'] == 200) {
      List listData = response.data['data'];
      for(Map map in listData) {
        print("map = " + map.toString());
        Request request = new Request(
          id: map['id'],
          username: map['username'],
          content: map['content'],
          type: map['type'],
          status: map['status'],
          avatarUrl: map['avatarUrl'],
        );
        listRequest.add(request);
      }
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("好友请求"),
        centerTitle: true,
      ),
      body:new ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              return RequestItem(request: listRequest[index]);
            },
            itemCount: listRequest.length,
          )
    );
  }
}


class RequestItem extends StatefulWidget {

  RequestItem({this.request});
  Request request;

  @override
  State createState() {
    return new _RequestItem(request: request);
  }
}

class _RequestItem extends State<RequestItem> {
  _RequestItem({this.request});
  Request request;
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
              child: Image.network(request.avatarUrl, fit: BoxFit.fill, height: 45,),
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
                  child: Text(request.username, style: TextStyle(fontSize: 20, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: new Text(request.content, style: TextStyle(fontSize: 16, color: Color(0xFFa9a9a9)), maxLines: 1, overflow: TextOverflow.ellipsis,),
                )
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: request.status == 0 ? new Row(
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
                  child: Text(request.status == 1 ? "添加成功" : "已经忽略", style: TextStyle(fontSize: 16, color: Color(0xFF353535)),  maxLines: 1, overflow: TextOverflow.ellipsis),
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
    int id = request.id;
    var response = await dio.put(
      GlobalConfig.baseUrl + "/request?requestId=$id&status=$status",
      );
    if(response.data['code'] == 200) {
      print("response = ");
      print(response);
      setState(() {
        this.request.status = status;
      });
    } else {
      Toast.toast(context, msg: "发生错误:" + response.data['message']);
    }
  }
}
