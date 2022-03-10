import 'package:flutter/material.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  DataBaseHelper helper = DataBaseHelper();
  String appBarTitle;
  Note note;
  static var _priorities = ["High", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    var _titleStyle = Theme.of(context).textTheme.titleMedium;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      onWillPop: () {
        return navigateBackToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 23),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              navigateBackToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: [
              ListTile(
                title: DropdownButton<String>(
                  items: _priorities.map((String dropDownMenuItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownMenuItem,
                      child: Text(dropDownMenuItem),
                    );
                  }).toList(),
                  value: updatePriorityAsString(note.priority),
                  style:
                      TextStyle(fontFamily: "Poppins", color: Colors.blueGrey),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  },
                ),
              ),

              // -------------  Title text field  ----------------
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: titleController,
                  style: _titleStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(fontFamily: "Poppins"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),

              // -------------  Description text field  ----------------
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: descriptionController,
                  style: _titleStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(fontFamily: "Poppins"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateBackToLastScreen() {
    Navigator.pop(context, true);
  }

  // ----------- Converting string priority into integer priority ------------
  void updatePriorityAsInt(String value) {
    switch (value) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
    }
  }

  // ----------- Converting Integer priority into string priority ------------
  String updatePriorityAsString(int value) {
    String priority = "Low";
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  // -------- Updating title from the text field ----------
  void updateTitle() {
    note.title = titleController.text;
  }

  // -------- Updating Description from the text field ------
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // ----- Save Button to save in data base --------
  void _save() async {
    navigateBackToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog("Status", "Note Saved Successfully!");
    } else {
      _showAlertDialog("Status", "Problem Saving Note!");
    }
  }

  // ------- Deleting Note ----------
  void _delete() async {
    navigateBackToLastScreen();
    if (note.id == null) {
      _showAlertDialog("Status", "First Create Note");
      return;
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog("Status", "Note Deleted Successfully!");
    } else {
      _showAlertDialog("Status", "Error Occurred while Deleting!");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
