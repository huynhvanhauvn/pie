import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/flash_card/blocs/copy_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/bloc.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';
import 'package:pie/screens/flash_card/flashcard_screen.dart';
import 'package:pie/screens/home/widgets/menu_item.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FlashCardRepository _flashCardRepository =
      FlashCardRepository(httpClient: http.Client());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuItem(
                    left: 16,
                    top: 16,
                    bottom: 8,
                    right: 8,
                    height: 100,
                    title: 'Vocabulary',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                          create: (context) => ListGroupBloc(
                                              repository:
                                                  _flashCardRepository)),
                                      BlocProvider(
                                        create: (context) => RenameGroupBloc(
                                            repository: _flashCardRepository),
                                      ),
                                      BlocProvider(
                                        create: (context) => DeleteGroupBloc(
                                            repository: _flashCardRepository),
                                      ),
                                      BlocProvider(
                                        create: (context) => CopyGroupBloc(
                                            repository: _flashCardRepository),
                                      ),
                                    ],
                                    child: FlashCardScreen(),
                                  )));
                    },
                  ),
                  MenuItem(
                    left: 16,
                    right: 8,
                    top: 8,
                    bottom: 16,
                    height: 200,
                    title: 'Speaking',
                  ),
                ],
              ),
              flex: 1,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuItem(
                    left: 8,
                    right: 16,
                    top: 16,
                    bottom: 8,
                    height: 200,
                    title: 'Listening',
                  ),
                  MenuItem(
                    left: 8,
                    right: 16,
                    top: 8,
                    bottom: 16,
                    height: 100,
                    title: 'Practice',
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
