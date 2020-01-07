
import 'package:chat/store/model/user_info.dart';
import 'package:chat/utils/shared_utils.dart';
import 'package:chat/config/GlobalConfig.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class UserProvider with ChangeNotifier {
  UserInfo _userInfo = new UserInfo();

  UserProvider() {
//    init();
    setId(100);
    setUsername("zhangsan");
    setAvatarUrl("https://pic4.zhimg.com/da8e974dc_is.jpg");
  }

  int get id => _userInfo.id;
  String get username => _userInfo.username;
  String get phone => _userInfo.phone;
  String get avatarUrl => _userInfo.avatarUrl;
  String get token => _userInfo.token;
  String get description => _userInfo.description;
  String get pushId => _userInfo.pushId;
  Object get user => _userInfo;
  int get status => _userInfo.status;

  setId(id) {
    _userInfo.id = id;
    notifyListeners();
  }

  setUsername(username) {
    _userInfo.username = username;
    notifyListeners();
  }

  setPhone(phone) {
    _userInfo.phone = phone;
    notifyListeners();
  }

  setAvatarUrl(avatarUrl) {
    _userInfo.avatarUrl = avatarUrl;
    notifyListeners();
  }

  setToken(token) {
    _userInfo.token = token;
    notifyListeners();
  }

  setDescription(description) {
    _userInfo.description = description;
    notifyListeners();
  }

  setPushId(pushId) {
    _userInfo.pushId = pushId;
    notifyListeners();
  }

  init() async {
    // setUsername("zhangsan");
    // setId(await sharedGetData("id"));
    // setPhone(await sharedGetData("phone"));
    // setUsername(await sharedGetData("username"));
    // setToken(await sharedGetData("token"));
    // setAvatarUrl(await sharedGetData("avatarUrl"));
    // setDescription(await sharedGetData("description"));
    // setPushId(await sharedGetData("pushId"));
  }

}
