import 'package:flutter/material.dart';
import 'package:notekeeper/screens/note_detail.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  late List<Note> noteList = [];
  int count = 0;

  // @override
  // void initState() {
  //   if (noteList == null){
  //     noteList = [];
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    if (noteList == null){
      noteList = [];
      updateListView();

    }
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Notes",
        style: TextStyle(
            fontSize: 23, fontFamily: "Poppins", fontWeight: FontWeight.w400),
      )),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note("","",2),"Add Note");
        },
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle? titlestyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),
            title: Text(
              noteList[position].title,
              style: titlestyle,
            ),
            subtitle: Text(noteList[position].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: (){
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetail(noteList[position],"Edit Note");
            },
          ),
        );
      },
    );
  }
  void navigateToDetail(Note note,String title)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note,title);
    }));

    if (result == true){
      updateListView();
    }
  }

  // -------- Return the priority color ---------
  Color getPriorityColor(int priority){
    switch (priority){
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // --------  Returning the priority Icon  ----------
  Icon getPriorityIcon(int priority){
    switch (priority){
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  //  ----------  Delete node when delete icon clicked  ---------
  void _delete(BuildContext context, Note note) async {
    int result = await dataBaseHelper.deleteNote(note.id);

    if (result != 0){
      _showSnackBar(context, "Note Deleted Successfully!");
      updateListView();
    }
  }

  // ------ showing SnackBar when note deleted  --------
  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(){
    final Future<Database> dbFuture = dataBaseHelper.initializeDataBase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = dataBaseHelper.getNodeList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

}
