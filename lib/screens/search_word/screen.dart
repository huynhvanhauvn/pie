import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/widgets/bottom_loader.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_string.dart';
import 'package:pie/utils/app_functions.dart';

class SearchWordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyState();
}

class MyState extends State<SearchWordScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
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
            return ListView.builder(
              itemCount: state.words.length,
              controller: _scrollController,
              itemBuilder: (context, i) {
                return i >= state.words.length
                    ? BottomLoader()
                    : ListTile(
                        onTap: () => viewWordDetail(words[i], context),
                        title: Text(words[i].word),
                      );
              },
            );
          }
          return Container();
        },
      ),
      appBar: AppBar(
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
              top: 8,
              bottom: 8,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none),
            fillColor: AppColor.grey.withOpacity(0.28),
            filled: true,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColor.primary,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }

  void _onScroll() {
    if (isEndList()) {
      _listBloc.add(SearchWord(keyword: _keyword));
    }
  }

  bool isEndList() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return maxScroll - currentScroll <= _scrollThreshold;
  }
}
