import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatebaseHelpher {
  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "myTable";
  static const columnId = "id";
  static const columnName = "name";

  static final DatebaseHelpher instance = DatebaseHelpher();
  //database initialize
  static Database? _database;
  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    db.execute(''' 
      CREATE TABLE $dbTable(
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,

      )
      
      ''');
  }

//Insert
  insert(Map<String, dynamic> row) async {
    print("Start insert");
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

  //Read
  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database? db = await instance.database;
    return await db!.query(dbTable);
  }

  //update

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(
      dbTable,
      row,
      where: "$columnId= ?",
      whereArgs: [id],
    );
  }

  //delete
  Future<int> delete(int id) async {
    Database? db = await instance.database;

    return await db!.delete(dbTable, where: "$columnId= ?", whereArgs: [id]);
  }
}
