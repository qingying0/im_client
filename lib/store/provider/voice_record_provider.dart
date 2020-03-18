import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/db/message_dao.dart';
import 'package:chat/socket/socket_manager.dart';
import 'package:chat/socket/upload.dart';
import 'package:chat/store/model/message.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter_plugin_record/flutter_plugin_record.dart';

import '../index.dart';
import 'message_provider.dart';


class VoiceRecordProvider with ChangeNotifier{

  bool ifTap;
  bool isCancel;
  FlutterPluginRecord recordPlugin;
  Message message;

  VoiceRecordProvider() {
    ifTap = false;
    isCancel = false;
    recordPlugin = new FlutterPluginRecord();
    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });
    init();
  }

  void init() async {
    /// 开始录制或结束录制的监听
    recordPlugin.response.listen((data) {
      if (data.msg == "onStop") {
        ///结束录制时会返回录制文件的地址方便上传服务器
        print("onStop  文件路径" + data.path);
        print("onStop  时长 " + data.audioTimeLength.toString());
        if(!isCancel) {
          message.content = data.path;
          File file = new File(data.path);
          upload.uploadfile(file, 1).then((path) {
            print(path);
            if(path != null) {
              sendMessage(message, path);
            }
          });
        } else {
          if(File(data.path).existsSync()) {
            File(data.path).delete();
          }
          isCancel = false;
          notifyListeners();
        }
      } else if (data.msg == "onStart") {
        print("onStart --");
      }else{
        print("--"+data.msg);
      }
    });
    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
      print("振幅大小" + voiceData.toString());
    });
  }

  void sendMessage(Message message, String url) async {
    print("message = " + message.toString());
    Dio dio = new Dio();
    dio.options = new Options(
        headers : {
    "token": await sharedGetData("token"),
    });
    FormData formData = FormData.from({
      "sessionId":message.sessionId,
      "type": 2,
      "content": url,
      "targetId": message.targetId
    });
    var response = await dio.post(GlobalConfig.baseUrl + "/message", data: formData);
    var data = response.data['data'];
    print(data);
    if(response.data['code'] == 200) {
      message.id = data['id'];
      message.status = 1;
      messageDao.insert(message);
      Store.value<MessageProvider>(socketManage.getContext()).addMessageBySessionId(message);
      Store.value<SessionProvider>(socketManage.getContext()).updateContent(message);
    }
  }

  @override
  void dispose() {
    recordPlugin.dispose();
    super.dispose();
  }

  beginRecord() {
    recordPlugin.init();
    ifTap = true;
    recordPlugin.start();
    notifyListeners();
  }

  void stopRecord()async {
    ifTap = false;
    await recordPlugin.stop();
    notifyListeners();
  }

  void cancelRecord() {
    ifTap = false;
    isCancel = true;
    recordPlugin.stop();
    notifyListeners();
  }

  playVoice(path) async {
    recordPlugin.playByPath(path);
  }

  void setMessage(Message message) {
    this.message = message;
  }
}
