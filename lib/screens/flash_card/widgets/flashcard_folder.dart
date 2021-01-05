import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/flash_card/widgets/flash_card.dart';
import 'package:pie/utils/app_type.dart';

class FlashCardFolder extends StatelessWidget {
  final FlashCardSeries data;
  final IntCallBack onViewMore;

  FlashCardFolder({this.data, this.onViewMore});

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
              Text(
                data.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.chevron_right_rounded, size: 40,), onPressed: () => onViewMore(data.id)),
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
