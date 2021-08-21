import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'item.dart';
class DBHelper{
  static Future<sql.Database> database() async{
    var docDir = await sql.getDatabasesPath();
    final dbPath = path.join(docDir,'item_datebase2.db');
    return await sql.openDatabase(
        dbPath,
    version: 1,
    onCreate: (db,ver) async{
          await db.execute(
          """CREATE TABLE ${Item.sql_table}(
             ${Item.sql_id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
             ${Item.sql_name} TEXT,
             ${Item.sql_date} TEXT,
             ${Item.sql_cost} INTEGER,
             ${Item.sql_amount} INTEGER,
             ${Item.sql_unitCode} INTEGER)"""
            );
    });
  }
  static Future<void> insertItem(Item item) async{
    log("insertItem");
    final sql.Database db = await database();
    await db.insert(Item.sql_table,
    item.toMap(),
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
  static Future<List<Item>> getItem() async{
    log("getItem");
    final sql.Database db = await database();
    final List<Map<String,dynamic>> maps = await db.query(Item.sql_table);
    var list =  List.generate(maps.length,
            (i) => Item(
              id: maps[i][Item.sql_id].toString(),
              name: maps[i][Item.sql_name].toString(),
              date: maps[i][Item.sql_date].toString(),
              cost: int.parse(maps[i][Item.sql_cost].toString()),
              amount: int.parse(maps[i][Item.sql_amount].toString()),
              unitCode: int.parse(maps[i][Item.sql_unitCode].toString()),
      )
    );
    return list;
  }
  static Future<void> updateItem(Item item) async{
    final sql.Database db = await database();
    await db.update(Item.sql_table, item.toMap(),
    where: "${Item.sql_id} = ?" ,
    whereArgs: [item.id],
    );
  }
  static Future<void> deleteItem(Item item) async{
    final sql.Database db = await database();
    await db.delete(Item.sql_table,
      where: "${Item.sql_id} = ?" ,
      whereArgs: [item.id],
    );
  }
}