import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/level.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/level_bloc/bloc.dart';
import 'package:pie/screens/Listening/blocs/level_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';
import 'package:pie/screens/Listening/unit_screen.dart';
import 'package:http/http.dart' as http;
import 'blocs/unit_bloc/bloc.dart';

class LevelScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LevelScreenState();
}

class LevelScreenState extends State<LevelScreen> {
  final ListeningRepository _listeningRepository = ListeningRepository(httpClient: http.Client());
  @override
  void initState() {
    BlocProvider.of<LevelBloc>(context).add(GetListLevel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: BlocBuilder<LevelBloc, LevelState>(
        builder: (context, state) {
          if (state is LevelSuccess && state.levels.length > 0) {
            final List<Level> levels = state.levels;
            return Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: levels.length,
                itemBuilder: (ctx, index) {
                  final Level level = levels[index];
                  return Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (level.allowed) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => UnitBloc(
                                          repository: _listeningRepository),
                                    ),
                                  ],
                                  child: UnitScreen(id: level.id,),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            color: level.allowed ? Colors.green : Colors.grey,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text('Level'),
                                Text(level.name ?? ''),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
