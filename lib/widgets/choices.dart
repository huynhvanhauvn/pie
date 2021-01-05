import 'package:flutter/material.dart';
import 'package:pie/models/choice.dart';
import 'package:pie/utils/app_type.dart';

enum Direction { horizontal, vertical }

class Choices extends StatefulWidget {
  final List<Choice> choices;
  final Direction direction;
  final IntCallBack onPress;

  Choices({this.choices, this.direction, this.onPress})
      : assert(choices != null, direction != null);

  @override
  State<StatefulWidget> createState() => ChoiceState();
}

class ChoiceState extends State<Choices> {
  var _value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
              children: widget.choices
                  .map(
                    (data) => RadioListTile(
                      groupValue: _value,
                      value: data.value,
                      title: Text(data.title),
                      onChanged: (value) {
                        widget.onPress(value);
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// class ChoiceTile extends StatefulWidget {
//   final Choice data;
//
//   ChoiceTile({this.data});
//
//   @override
//   State<StatefulWidget> createState() => ChoiceTileState();
// }
//
// class ChoiceTileState extends State<ChoiceTile> {
//   int _value = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Radio(
//           groupValue: _value,
//           value: widget.data.value,
//           onChanged: (val) {
//             print(_value);
//             setState(() => _value = val);
//           },
//         ),
//         Text(widget.data.title),
//       ],
//     );
//   }
// }
