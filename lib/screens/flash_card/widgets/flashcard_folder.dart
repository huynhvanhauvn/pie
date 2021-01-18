import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/bloc.dart';
import 'package:pie/screens/flash_card/widgets/flash_card.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_type.dart';

class FlashCardFolder extends StatelessWidget {
  final FlashCardSeries data;
  final CallBack onViewMore;
  final _controller = TextEditingController();

  FlashCardFolder({this.data, this.onViewMore});

  void showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                FlatButton(
                  onPressed: () => {
                    BlocProvider.of<RenameGroupBloc>(context).add(RenameSeries(id: data.id, name: _controller.text,))fr sr4;
                  },
                  child: Text('Change'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showRenameDialog(context);
                    },
                    child: Text('Rename'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () => goToAdd(context, data.id),
                    child: Text('Add Words'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    child: Text(
                      'Delete Group',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showMenu(context),
                child: Text(
                  data.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    size: 40,
                  ),
                  onPressed: () => onViewMore(data.id)),
            ],
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.words.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, i) {
              return FlashCardItem(
                word: data.words[i],
                index: i,
              );
            },
          ),
        ),
      ],
    );
  }
}
