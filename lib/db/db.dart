
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {

  static const int _VERSION = 1;

  static const String _DB_NAME = "message.db";

  static Database _database;

  static String messageTableName = "message";
  static String messageCreateSql = '''
            CREATE TABLE message (
            id` integer NOT NULL PRIMARY KEY,
            content` text NOT NULL,
            create_time` integer NOT NULL DEFAULT CURRENT_TIMESTAMP,
            send_id` integer NOT NULL,
            type` integer NOT NULL,
            status` integer NOT NULL,
            session_id` integer NOT NULL)
          ''';

  static init() async {
    var databasePath = await getDatabasesPath();
    String dbName = _DB_NAME;
    String path = databasePath + dbName;
    if(Platform.isIOS) {
      path = databasePath + "/" + dbName;
    }

    _database = await openDatabase(path,version: _VERSION, 
      onCreate: (Database db, int version) {
      });

    isTableExist(messageTableName).then((v) {
      if(!v) {
        _database.execute(messageCreateSql);
      }  
    });
  }

  static Future<bool> isTableExist(String tableName) async {
    await getCurrentDatabase();
    String sql = "select * from Sqlite_master where type = 'table' and name = '$tableName'";
    var res = await _database.rawQuery(sql);
    return res != null && res.length > 0;
  }

  static Future<Database> getCurrentDatabase() async {
    if(_database == null) {
      await init();
    }
    return _database;
  }


  static close() {
    _database?.close();
    _database = null;
  }
}