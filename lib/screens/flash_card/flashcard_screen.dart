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
              print(state);
              if(state is ListGroupSuccess) {
                print(state.series);
                final List<FlashCardSeries> series = state.series;
                return Column(
                  children: series != null && series.length > 0 ? series
                       .map(
                        (e) => e.words != null && e.words.length > 0 ? FlashCardFolder(
                      data: e,
                      onViewMore: (id) => viewCardFolder(
                        context: context,
                        idFolder: id,
                      ),
                    ) : Container(),
                  )
                      .toList() : [],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.qr_code),
      ),
    );
  }
}