import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pie/models/word.dart';

class FlashCardItem extends StatefulWidget {
  final Word word;
  final int index;

  FlashCardItem({this.word, this.index});

  @override
  State<StatefulWidget> createState() => FlashCardItemState();
}

class FlashCardItemState extends State<FlashCardItem> {
  FlutterTts tts = FlutterTts();

  Future _speak() async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(1.0);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    var result = await tts.speak(widget.word.word);
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.4,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 16,
                child: IconButton(
                  onPressed: () => _speak(),
                  icon: Icon(
                    Icons.volume_up_rounded,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.word.word,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      Text(
                        '(${widget.word.type})',
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                      ),
                      Text(
                        widget.word.meaning,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    return GestureDetector(
      onTap: () => displayBottomSheet(context),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              word.word,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '(${word.type})',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              word.meaning,
            ),
          ],
        ),
        width: 200,
        height: double.infinity,
        margin: EdgeInsets.only(
          left: widget.index == 0 ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.28),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
