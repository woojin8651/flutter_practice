import 'dart:developer';
import 'package:flutter_practice_app/model/Budget.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBBudgetHelper{
  static Future<sql.Database> database() async{
    var docDir = await sql.getDatabasesPath();
    final dbPath = path.join(docDir,'budget_datebase.db');
    return await sql.openDatabase(
        dbPath,
        version: 1,
        onCreate: (db,ver) async{
          await db.execute(
              """CREATE TABLE ${Budget.sql_table}(
             ${Budget.sql_id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
             ${Budget.sql_total} INTEGER,
             ${Budget.sql_repeat} INTEGER,
             ${Budget.sql_repeatDay} TEXT,
             ${Budget.sql_repeatP} TEXT,
             ${Budget.sql_stDay} TEXT)
             ${Budget.sql_edDay} TEXT)"""
          );
        });
  }
  static Future<void> insertBudget(Budget budget) async{

    final sql.Database db = await database();
    await db.insert(Budget.sql_table,
        budget.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
  static Future<List<Budget>> getBudget() async{

    final sql.Database db = await database();
    final List<Map<String,dynamic>> maps = await db.query(Budget.sql_table);
    var list =  List.generate(maps.length,
            (i) => Budget(
              id: maps[i][Budget.sql_id].toString(),
              total: int.parse(maps[i][Budget.sql_total].toString()),
              repeat: int.parse(maps[i][Budget.sql_repeat].toString()),
              repeatDay: int.parse(maps[i][Budget.sql_repeatDay].toString()),
              repeatP: maps[i][Budget.sql_repeatP].toString(),
              stDay: maps[i][Budget.sql_stDay].toString(),
              edDay: maps[i][Budget.sql_edDay].toString(),
        )
    );
    return list;
  }
  static Future<void> updateBudget(Budget budget) async{
    final sql.Database db = await database();
    await db.update(Budget.sql_table, budget.toMap(),
      where: "${Budget.sql_id} = ?" ,
      whereArgs: [budget.id],
    );
  }
  static Future<void> deleteBudget(Budget budget) async{
    final sql.Database db = await database();
    await db.delete(Budget.sql_table,
      where: "${Budget.sql_id} = ?" ,
      whereArgs: [budget.id],
    );
  }
}