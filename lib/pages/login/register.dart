import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/utils/toast.dart';
import 'package:flutter/services.dart';
class Register extends StatefulWidget {
  @override
  State createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              new BackButton(),
              new Text("Sign up",
                textScaleFactor: 2,
                style: TextStyle(
                  color: const Color(0xff000000),
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width * 0.96,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _usernameController,
                        decoration: new InputDecoration(
                          hintText: 'Username',
                          icon: new Icon(
                            Icons.account_circle,
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
                      TextField(
                        controller: _phoneController,
                        obscureText: true,
                        keyboardType: TextInputType.phone,
                        decoration: new InputDecoration(
                          hintText: 'phone',
                          icon: new Icon(
                              Icons.phone
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                      new FlatButton(
                        child: new Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 30,
                          decoration: new BoxDecoration(
                              color: Colors.blue
                          ),
                          child: new Center(
                              child: new Text("sign up",
                                  style: new TextStyle(
                                    color: const Color(0xff000000),
                                  ))),
                        ),
                        onPressed: () {
                          if(_usernameController.text.length <= 2) {
                            Toast.toast(context, msg: "用户名长度太短");
                          // } else if(_passwordController.text.length <= 6) {
                          //   Toast.toast(context, msg: "密码长度太短");
                          // } else if(_phoneController.text.length != 11) {
                          //   Toast.toast(context, msg: "手机号不符合格式");
                          } else {
                            register();
                          }
                        },
                      ),
                      Center(
                        child: FlatButton(
                          child: Text("have an account? login in",
                            style: TextStyle(
                              color: const Color(0xff000000),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ]
                ),

              )
            ],
          )

        ]));
  }

  register() async{
    var username = _usernameController.text;
    var password = _passwordController.text;
    var phone = _phoneController.text;
    Dio dio = new Dio();
    var response = await dio.post("http://" + GlobalConfig.address + "/register?username=$username&password=$password&phone=$phone");
    if(response.data['code'] == 200) {
      Toast.toast(context, msg: "注册成功，请登录");
      Navigator.of(context).pop();
    } else {
      Toast.toast(context, msg: "注册失败，" + response.data['message']);
      this._phoneController.text = "";
    }
  }
}
