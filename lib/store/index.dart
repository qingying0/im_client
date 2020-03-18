import 'package:chat/store/provider/friends_provider.dart';
import 'package:chat/store/provider/message_provider.dart';
import 'package:chat/store/provider/request_provider.dart';
import 'package:chat/store/provider/sessions_provider.dart';
import 'package:chat/store/provider/userinfo_provider.dart';
import 'package:chat/store/provider/voice_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider//user_provider.dart';

class Store {

  static BuildContext widgetCtx;

  static init({context, child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=>UserProvider(),),
        ChangeNotifierProvider(builder: (_)=>UserInfoProvider(),),
        ChangeNotifierProvider(builder: (_)=>FriendsProvider(),),
        ChangeNotifierProvider(builder: (_)=>SessionProvider(),),
        ChangeNotifierProvider(builder: (_)=>MessageProvider(),),
        ChangeNotifierProvider(builder: (_)=>RequestProvider(),),
        ChangeNotifierProvider(builder: (_)=>VoiceRecordProvider(),),
      ],
      child: child,
    );
  }

  static T value<T>(context) {
    return Provider.of<T>(context);
  }

  static Consumer connect<T>({builder, child}) {
    return Consumer<T>(builder: builder, child: child,);
  }
}
