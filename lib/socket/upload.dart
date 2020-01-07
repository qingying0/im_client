

import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';

Upload upload = new Upload();

class Upload {
  Future<String> uploadfile(File file) async{
    String path = file.path;
    print(path);
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    print(name);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(path), name)
    });
    Dio dio = new Dio();
    var response = await dio.post(GlobalConfig.baseUrl + "/user/upload", data:formData);
    print(response);
    if(response.data['code'] == 200) {
      return response.data['data'];
    }
  }
}