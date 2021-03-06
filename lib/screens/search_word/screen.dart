import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';
import 'package:pie/screens/search_word/blocs/add_group_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/add_group_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/add_word_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/add_word_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/widgets/bottom_loader.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_string.dart';
import 'package:http/http.dart' as http;

class SearchWordScreen extends StatefulWidget {
  final String idSeries;
  final VoidCallback onDone;

  const SearchWordScreen({Key key, this.idSeries, this.onDone})
      : super(key: key);

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
  void dispose() {
    _scrollController.dispose();
    _wordsStream.close();
    super.dispose();
  }

  void showGroupNameDialog(BuildContext context, List<Word> words) {
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
                    BlocProvider.of<AddGroupBloc>(context).add(AddGroup(
                      words: words,
                      groupName: _controller.text,
                    ));
                    Navigator.pop(ctx);
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showListGroup(BuildContext context, List<Word> words) async {
    final List<FlashCardSeries> series =
        await FlashCardRepository(httpClient: http.Client()).getListGroup();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select a Group to Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.pop(ctx);
                          showGroupNameDialog(context, words);
                        },
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Divider(
                    height: 0.5,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: series.length,
                      itemBuilder: (listCtx, index) {
                        final FlashCardSeries group = series[index];
                        return ListTile(
                          title: Text(group.title),
                          onTap: () {
                            Navigator.pop(ctx);
                            showAlertDialog(
                              context: context,
                              title: 'Confirm',
                              content:
                                  'Do you want to add selected words to ${group.title}?',
                              onContinue: () {
                                BlocProvider.of<AddWordBloc>(context)
                                    .add(AddWord(
                                  words: words,
                                  idSeries: group.id,
                                ));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          MultiBlocListener(
            listeners: [
              BlocListener<AddWordBloc, AddWordState>(
                listener: (ctx, state) {
                  print('add w ${state}');
                  if (state is AddWordSuccess) {
                    widget.onDone();
                    Navigator.of(context).pop();
                  }
                },
              ),
              BlocListener<AddGroupBloc, AddGroupState>(
                listener: (ctx, state) {
                  print('add g ${state}');
                  if (state is AddGroupSuccess) {
                    widget.onDone();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            child: StreamBuilder<List<Word>>(
              stream: _wordsStream.stream,
              initialData: [],
              builder: (ctx, snapshot) {
                final List<Word> _words =
                    snapshot.data.where((element) => element.selected).toList();
                return IconButton(
                  enableFeedback: _words.length > 0,
                  disabledColor: Colors.grey,
                  icon: Icon(
                    Icons.check,
                    size: 32,
                  ),
                  onPressed: _words.length > 0
                      ? () {
                          print(widget.idSeries);
                          if (widget.idSeries != null) {
                            BlocProvider.of<AddWordBloc>(context).add(AddWord(
                              words: _words,
                              idSeries: widget.idSeries,
                            ));
                          } else {
                            showListGroup(context, _words);
                          }
                        }
                      : null,
                );
              },
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.pink, Colors.yellow],
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
          ),
        ),
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
