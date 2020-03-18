

import 'dart:io';

import 'package:chat/config/GlobalConfig.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:dio/dio.dart';

Upload upload = new Upload();

class Upload {
  Future<String> uploadfile(File file, int fileType) async{
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, name),
      "fileType": fileType,
    });
    Dio dio = new Dio();
    dio.options = new Options(
      headers : {
        "token": await sharedGetData("token"),
    });
    var response = await dio.post(GlobalConfig.baseUrl + "/file", data:formData);
    if(response.data['code'] == 200) {
      return response.data['data'];
    }
  }
}
