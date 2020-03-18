import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/pages/login/register.dart';
import 'package:chat/store/index.dart';
import 'package:chat/store/provider//user_provider.dart';
import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/pages/home/mainhome.dart';
import 'package:chat/utils/toast.dart';
import 'package:chat/socket/socket_manager.dart';

class Login extends StatefulWidget {
  @override
  State createState() => new _Login();

}
class _Login extends State<Login> {


  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    socketManage.setContext(context);
    return new Scaffold(
        body: new Stack(children: <Widget>[
          new Opacity(
              opacity: 0.5,
              child: new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: NetworkImage("https://i0.hdslb.com/bfs/article/7788807d72c235424f348e3bc20c4c571c7c27bc.jpg@1320w_1844h.webp"),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            controller: _phoneController,
                            decoration: new InputDecoration(
                              hintText: 'Phone',
                              icon: new Icon(
                                Icons.phone
                              ),
                            ),

                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              hintText: 'Password',
                              icon: new Icon(
                                Icons.lock_outline,
                              ),
                            ),
                          ),
                          Store.connect<UserInfoProvider>(
                            builder: (context, snapshot, child) {
                              return new FlatButton(
                                child: new Container(
                                  margin: EdgeInsets.only(top: 30),
                                  height: 30,
                                  decoration: new BoxDecoration(
                                      color: Colors.blue
                                  ),
                                  child: new Center(
                                      child: new Text("login In ",
                                          style: new TextStyle(
                                            color: const Color(0xff000000),
                                          ))),
                                ),
                                onPressed: () {
                                    login();
                                },
                              );
                            }
                          ),
                          Center(
                            child: FlatButton(
                              child: Text("Don't have an account? sign up",
                                style: TextStyle(
                                  color: const Color(0xff000000),
                                ),
                              ),
                              onPressed: ()=> {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return Register();
                                    }
                                ))
                              }
                            ),
                          )

                        ]
                    ),

                  )
              )
            ],
          )
        ]));

  }

  login() async{
    var phone = _phoneController.text;
    var password = _passwordController.text;
    Dio dio = new Dio();
    var response = await dio.get("http://" + GlobalConfig.address + "/login?phone=$phone&password=$password");
    var data = response.data['data'];
    if(response.data['code'] == 200) {
      sharedAddAndUpdate('username', String, data['username']);
      sharedAddAndUpdate('phone', String, data['phone']);
      sharedAddAndUpdate('avatarUrl', String, data['avatarUrl']);
      sharedAddAndUpdate('token', String, data['token']);
      sharedAddAndUpdate('id', int, data['id']);
      Store.value<UserInfoProvider>(context).init();
      GlobalConfig.setInitFriend();
      GlobalConfig.setInitSession();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return MainHome();
        }
      ));
    } else {
      Toast.toast(context, msg: "登录失败:" + response.data['message']);
    }
  }
}
