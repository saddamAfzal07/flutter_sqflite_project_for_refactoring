import 'dart:io';

import 'package:flutter_sqflite_project/model/notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelpher {
  //database initialize
  static Database? _db;
  Future<Database?> get database async {
    _db ??= await initDB();
    return _db;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "notes.db");
    var db = openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  Future onCreate(Database db, int version) async {
    db.execute(
      "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL, age INTEGER NOT NULL,description TEXT NOT NULL,email Text)",
    );
  }

//Insert
  Future<NotesModel> insert(NotesModel notesModel) async {
    print("Start insert");
    var _dbclient = await database;
    await _dbclient!.insert("notes", notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async {
    print("Get Notes List");
    var _dbclient = await database;
    final List<Map<String, Object?>> queryResult =
        await _dbclient!.query("notes");
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  //update
  Future<int> update(NotesModel notesModel) async {
    var _dbclient = await database;

    return await _dbclient!.update("notes", notesModel.toMap(),
        where: "id=?", whereArgs: [notesModel.id]);
  }

  //delete
  Future<int> delete(int id) async {
    var _dbclient = await database;

    return await _dbclient!.delete("notes", where: "id = ?", whereArgs: [id]);
  }
}
