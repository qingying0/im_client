import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/socket/upload.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserData extends StatelessWidget {

  BuildContext context;

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Store.connect<UserInfoProvider>(
      builder: (context, snapshot, child) {
      _usernameController.text = snapshot.username ;
      _descriptionController.text = snapshot.description;
      return new Scaffold(
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width * 0.6,
              child: new FlatButton(
                  child: new ClipOval(
                    child: snapshot.avatarUrl == null ? Image.network("http://q3jbezsht.bkt.clouddn.com/489a86ddd283bafd.jpg") :
                    Image.network(snapshot.avatarUrl),
                  ),
                  onPressed: () {
                    getImage();
                  },
                ),
            ),
            new TextField(
              controller: _usernameController,

              decoration: new InputDecoration(
                hintText: "用户名",
                icon: new Icon(
                  Icons.account_circle
                ),
              ),

            ),
            new TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                hintText: "个性签名",
                icon: new Icon(
                  Icons.description,
                ),
              ),
            ),
            new FlatButton(
              child: new Container(
                margin: EdgeInsets.only(top: 30),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: new BoxDecoration(
                    color: Colors.blue
                ),
                child: new Center(
                    child: new Text("修改资料 ",
                        style: new TextStyle(
                          color: const Color(0xff000000),
                        ))),
              ),
              onPressed: () {
                updateUser();
              },
            ),
          ],
          ),
        );
      }
    );
  }

  getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    int id = await sharedGetData("id");
    String fileType = image.path.split(".")[image.path.split(".").length - 1];
    print(fileType);
    String fileName = "avatarUrl:" + id.toString() + "." + fileType;
    upload.uploadfile(image, 0).then((url) {
      updateAvatar(url);
    });
  }

  updateAvatar(String url) async{
    Dio dio = new Dio();
    dio.options = new Options(
      headers : {
        "token": await sharedGetData("token"),
    });
    var response = await dio.put(GlobalConfig.baseUrl + "/user?avatarUrl=$url");
    if(response.data['code'] == 200) {
      Store.value<UserInfoProvider>(context).setAvatarUrl(url);
    }
  }

  updateUser() async{
    Dio dio = new Dio();
    dio.options = new Options(
      headers : {
        "token": await sharedGetData("token"),
    });
    String username = _usernameController.text;
    String description = _descriptionController.text;
    var response = await dio.put(GlobalConfig.baseUrl + "/user?username=$username&description=$description");
    if(response.data['code'] == 200) {
      Store.value<UserInfoProvider>(context).setUsername(_usernameController.text);
      Store.value<UserInfoProvider>(context).setDescription(_descriptionController.text);
      Toast.toast(context, msg: "修改成功");
    }
  }
}
