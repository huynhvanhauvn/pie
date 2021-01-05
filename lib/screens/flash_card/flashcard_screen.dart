import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/state.dart';
import 'package:pie/screens/flash_card/widgets/flashcard_folder.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';
import 'package:pie/screens/search_word/screen.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:http/http.dart' as http;

class FlashCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FlashCardScreenState();
}

class FlashCardScreenState extends State<FlashCardScreen> {
  final List<Word> words = [
    Word(id: 0, word: 'run', type: 'v', meaning: 'Chạy', picture: ''),
    Word(id: 1, word: 'learn', type: 'v', meaning: 'Học tập', picture: ''),
    Word(id: 2, word: 'house', type: 'n', meaning: 'Nhà', picture: ''),
  ];

  @override
  void initState() {
    BlocProvider.of<ListGroupBloc>(context).add(GetListGroup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<ListGroupBloc, ListGroupState>(
            builder: (context, state) {
              if(state is ListGroupSuccess) {
                final List<FlashCardSeries> series = state.series;
                return Column(
                  children: series
                       .map(
                        (e) => FlashCardFolder(
                      data: e,
                      onViewMore: (id) => viewCardFolder(
                        context: context,
                        idFolder: id,
                      ),
                    ),
                  )
                      .toList(),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Flashcard List',
          style: TextStyle(color: AppColor.primary),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColor.primary,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColor.primary,
              size: 30,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ListBloc(
                        repository: ListRepository(
                          httpClient: http.Client(),
                        ),
                      ),
                    ),
                  ],
                  child: SearchWordScreen(),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}