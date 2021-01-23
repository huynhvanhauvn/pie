import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/flash_card/blocs/copy_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/copy_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';
import 'package:pie/screens/flash_card/widgets/flashcard_folder.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';
import 'package:pie/screens/search_word/screen.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:http/http.dart' as http;
import 'package:qrscans/qrscan.dart' as scanner;

class FlashCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FlashCardScreenState();
}

class FlashCardScreenState extends State<FlashCardScreen> {
  final FlashCardRepository _flashCardRepository =
      FlashCardRepository(httpClient: http.Client());

  @override
  void initState() {
    BlocProvider.of<ListGroupBloc>(context).add(GetListGroup());
    super.initState();
  }

  Future scanQRCode() async {
    String result = await scanner.scan();
    if (result != null && result.length > 0) {
      BlocProvider.of<CopyGroupBloc>(context).add(CopySeries(id: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<ListGroupBloc, ListGroupState>(
            builder: (context, state) {
              print(state);
              if (state is ListGroupSuccess) {
                print(state.series);
                final List<FlashCardSeries> series = state.series;
                return Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: series != null && series.length > 0
                        ? series
                            .map(
                              (e) => e.words != null && e.words.length > 0
                                  ? MultiBlocListener(
                                      listeners: [
                                        BlocListener<RenameGroupBloc,
                                            RenameGroupState>(
                                          listener: (context, state) {
                                            if (state is RenameGroupSuccess) {
                                              BlocProvider.of<ListGroupBloc>(
                                                      context)
                                                  .add(GetListGroup());
                                            }
                                          },
                                        ),
                                        BlocListener<DeleteGroupBloc,
                                            DeleteGroupState>(
                                          listener: (context, state) {
                                            if (state is DeleteGroupSuccess) {
                                              BlocProvider.of<ListGroupBloc>(
                                                      context)
                                                  .add(GetListGroup());
                                            }
                                          },
                                        ),
                                        BlocListener<CopyGroupBloc,
                                            CopyGroupState>(
                                          listener: (context, state) {
                                            print(state);
                                            if (state is CopyGroupSuccess) {
                                              BlocProvider.of<ListGroupBloc>(
                                                      context)
                                                  .add(GetListGroup());
                                            }
                                          },
                                        ),
                                      ],
                                      child: FlashCardFolder(
                                        data: e,
                                        onViewMore: (id) => viewCardFolder(
                                          context: context,
                                          idFolder: id,
                                          onChangeData: () =>
                                              BlocProvider.of<ListGroupBloc>(
                                                      context)
                                                  .add(GetListGroup()),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                            .toList()
                        : [],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Flashcard List',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
        ),
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQRCode,
        child: Icon(Icons.qr_code),
      ),
    );
  }
}
