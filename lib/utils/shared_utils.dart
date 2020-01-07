import 'package:shared_preferences/shared_preferences.dart';

sharedAddAndUpdate(String key,Object dataType,Object data) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  switch(dataType){
    case bool:
    sharedPreferences.setBool(key, data);
    break;
    case double:
    sharedPreferences.setDouble(key, data);
    break;
    case int:
    sharedPreferences.setInt(key, data);
    break;
    case String:
    sharedPreferences.setString(key, data);
    break;
    case List:
    sharedPreferences.setStringList(key, data);
    break;
    default:
    sharedPreferences.setString(key, data.toString());
    break;
  }
}

Future<Object> sharedGetData(String key) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.get(key);
}

sharedDeleteData(String key) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(key);
}
