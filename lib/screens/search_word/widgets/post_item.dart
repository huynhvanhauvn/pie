import 'package:flutter/material.dart';
import 'package:pie/models/word.dart';

class WordWidget extends StatelessWidget {
  final Word word;

  const WordWidget({Key key, @required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Text(
      //   '${word.id}',
      //   style: TextStyle(fontSize: 10.0),
      // ),
      title: Text(word.word),
      isThreeLine: true,
      subtitle: Text(word.meaning),
      dense: true,
    );
  }
}