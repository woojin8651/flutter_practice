import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
class DBHelper{
  static Future<sql.Database> database() async{
    var docDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docDir.path,'app.db');
    return await sql.openDatabase(
        dbPath,
    version: 1,
    onCreate: (db,ver) async{
          await db.execute('''
            CREATE TABLE
          ''');
    });
  }
}