import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/search_word/blocs/add_word_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/widgets/bottom_loader.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_string.dart';

class SearchWordScreen extends StatefulWidget {
  final String idSeries;

  const SearchWordScreen({Key key, this.idSeries}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyState();
}

class MyState extends State<SearchWordScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final StreamController<List<Word>> _wordsStream = StreamController();
  ListBloc _listBloc;
  String _keyword;

  @override
  void initState() {
    _keyword = '';
    _scrollController.addListener(_onScroll);
    _listBloc = BlocProvider.of<ListBloc>(context);
    _listBloc.add(SearchWord(keyword: _keyword, isRefresh: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListSuccess) {
            final words = state.words;
            _wordsStream.add(words);
            return ListView.builder(
              itemCount: state.words.length,
              controller: _scrollController,
              itemBuilder: (context, i) {
                return i >= state.words.length
                    ? BottomLoader()
                    : ListTile(
                        // onTap: () => viewWordDetail(words[i], context),
                        title: Text(words[i].word),
                        trailing: Checkbox(
                          value: words[i].selected,
                          onChanged: (value) =>
                              BlocProvider.of<ListBloc>(context).add(
                            SelectWord(word: words[i], value: value),
                          ),
                        ),
                      );
              },
            );
          }
          return Container();
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: TextField(
          onChanged: (keyword) {
            print(keyword);
            _listBloc.add(SearchWord(keyword: keyword, isRefresh: true));
            setState(() {
              _keyword = keyword;
            });
          },
          decoration: InputDecoration(
            hintText: txt.password,
            hintStyle: TextStyle(color: AppColor.text),
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none),
            fillColor: Colors.black.withOpacity(0.28),
            filled: true,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          StreamBuilder<List<Word>>(
            stream: _wordsStream.stream,
            initialData: [],
            builder: (context, snapshot) {
              final List<Word> _words = snapshot.data.where((element) => element.selected).toList();
              return IconButton(
                enableFeedback: _words.length > 0,
                disabledColor: Colors.grey,
                icon: Icon(
                  Icons.check,
                  size: 32,
                ),
                onPressed: _words.length > 0 ? () {
                  print(widget.idSeries);
                  if (widget.idSeries != null) {
                    BlocProvider.of<AddWordBloc>(context)
                        .add(AddWord(_words, widget.idSeries));
                  }
                } : null,
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
        ),
        elevation: 0.0,
      ),
    );
  }

  void _onScroll() {
    if (isEndList()) {
      _listBloc.add(SearchWord(
        keyword: _keyword,
        isRefresh: false,
      ));
    }
  }

  bool isEndList() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return maxScroll - currentScroll <= _scrollThreshold;
  }
}
