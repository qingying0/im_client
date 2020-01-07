import 'package:chat/db/db.dart';
import 'package:chat/store/model/message.dart';
import 'package:sqflite/sqflite.dart';

MessageDao messageDao = new MessageDao();

class MessageDao {

  String name = "message";

  final String columnId = "id";

  tableName() {
    return name;
  }


  tableSqlString() {
    return "id, content, create_time, send_id, target_id, type, status, session_id";
  }

  Future<List<Map<String, dynamic>>> getMessageBySessionId(int sessionId) async{
    Database db = await DBManager.getCurrentDatabase();
    List<Map<String, dynamic>> map = await db.query(
      this.name,
      where: "session_id = ?",
      whereArgs: [sessionId],
    );
    return map;
  }

  Future insert(Message message) async {
    Database db = await DBManager.getCurrentDatabase();
    return await db.insert(this.name, toMap(message));
  }

  Future clear() async {
    Database db = await DBManager.getCurrentDatabase();
    await db.delete(
      this.name,
    );
  }

  Map<String, dynamic> toMap(Message message) {
    Map<String, dynamic> map = {
      "id": message.id,
      "send_id": message.sendId,
      "session_id": message.sessionId,
      "type": message.type,
      "create_time": message.createTime.millisecondsSinceEpoch,
      "content": message.content,
      "status": message.status,
    };
    return map;
  }
}