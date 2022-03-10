import 'package:flutter/material.dart';
import 'package:notekeeper/screens/note_list.dart';

import 'screens/note_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteKeeper",
      home: NoteList(),
      theme: ThemeData(primarySwatch: Colors.red),
    );
  }
}


