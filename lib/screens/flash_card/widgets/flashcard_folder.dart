import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/bloc.dart';
import 'package:pie/screens/flash_card/widgets/flash_card.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_type.dart';
import 'package:qrscans/qrscan.dart' as scanner;

class FlashCardFolder extends StatelessWidget {
  final FlashCardSeries data;
  final CallBack onViewMore;
  final VoidCallback onDone;

  FlashCardFolder({this.data, this.onViewMore, this.onDone});

  void showRenameDialog(BuildContext context) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
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
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                FlatButton(
                  color: AppColor.primary,
                  onPressed: () {
                    BlocProvider.of<RenameGroupBloc>(context).add(RenameSeries(
                      id: data.id,
                      name: _controller.text,
                    ));
                    Navigator.pop(ctx);
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

  void showQRDialog(BuildContext context) async {
    final screen = MediaQuery.of(context).size;
    Uint8List _image = await scanner.generateBarCode(data.id);
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: screen.width - 80,
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(_image, scale: 1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
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
                      Navigator.pop(ctx);
                      showRenameDialog(context);
                    },
                    child: Text('Rename'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () => goToAdd(
                      context: context,
                      idSeries: data.id,
                      onDone: onDone,
                    ),
                    child: Text('Add Words'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      showQRDialog(context);
                    },
                    child: Text('Share'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      showAlertDialog(
                          context: context,
                          title: 'Confirm',
                          content: 'Do you want to delete this group?',
                          onContinue: () {
                            BlocProvider.of<DeleteGroupBloc>(context)
                                .add(DeleteSeries(id: data.id));
                          });
                    },
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
    final screen = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => showMenu(context),
          child: Container(
            width: screen.width * 4 / 5,
            padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    size: 32,
                  ),
                  onPressed: () => onViewMore(data.id),
                ),
              ],
            ),
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
