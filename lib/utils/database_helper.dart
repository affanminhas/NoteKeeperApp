import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/models/note.dart';

class DataBaseHelper{
  static  DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  String noteTable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DataBaseHelper._createInstance();

  factory DataBaseHelper(){
    if (_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper!;
  }

  Future<Database> get database async {
    if (database == null){
      _database = await initializeDataBase();
    }
    return _database!;
  }

  Future<Database> initializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    var notesDataBase = await openDatabase(path, version: 1, onCreate: _createDataBase);
    return notesDataBase;
  }

  void _createDataBase(Database db, int newVersion) async{
    await db.execute("CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,"
        "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  // --------  get all note object from database  ----------
  Future<List<Map<String, dynamic>>>getNoteMapList() async {
    Database db = await this.database;

    var result = await db.query(noteTable, orderBy: "$colPriority ASC");
    // var result = await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");
    return result;
  }

  // --------- insert a note object to database  -------------
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // ---------  update a note object and save it to database ---------
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  // --------  delete node from database ------------
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete("DELETE FROM $noteTable WHERE $colId = $id");
    return result;
  }

  // -------- get number of notes object  ----------
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery("SELECT COUNT (*) from $noteTable ");
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  // -------- Get the map list from database and convert it into node list  -----------
  Future<List<Note>> getNodeList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = [];
    for(int i=0; i < count; i++ ){
      noteList.add(Note.fromMapToObject(noteMapList[i]));
    }
    return noteList;
  }


}