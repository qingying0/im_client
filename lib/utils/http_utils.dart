
import 'package:chat/store/index.dart';
import 'package:chat/store/provider//user_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class HttpUtils{

  static Options getOption(BuildContext context) {
    return new Options(
    headers : {
      "token": Store.value<UserInfoProvider>(context).token,
    }
  );
  }
}
