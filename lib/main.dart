import 'package:chat/pages/home/mainhome.dart';
import 'package:chat/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/shared_utils.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var id = await sharedGetData("id");

  if(id == null) {
    runApp(MyApp());
  } else {
    runApp(MyHome(id: id,));
  }
}


class MyApp extends StatelessWidget {

  final ThemeData defaultTheme = new ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.grey[100],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login(),);
  }
}

class MyHome extends StatelessWidget {

  MyHome({this.id});
  int id;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainHome(),);
  }
}
