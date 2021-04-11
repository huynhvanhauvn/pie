import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/unit.dart';
import 'package:pie/screens/Listening/audio_list_screen.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';
import 'package:pie/screens/Listening/blocs/unit_bloc/bloc.dart';
import 'package:pie/screens/Listening/blocs/unit_bloc/state.dart';
import 'package:http/http.dart' as http;

import 'blocs/audio_bloc/bloc.dart';

class UnitScreen extends StatefulWidget {
  final id;

  UnitScreen({this.id});

  @override
  State<StatefulWidget> createState() => UnitScreenState();
}

class UnitScreenState extends State<UnitScreen> {
  final ListeningRepository _listeningRepository =
      ListeningRepository(httpClient: http.Client());
  final List<Color> colors = [
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.blue,
    Colors.amber
  ];

  @override
  void initState() {
    BlocProvider.of<UnitBloc>(context).add(GetListUnit(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UnitBloc, UnitState>(
        builder: (context, state) {
          if (state is UnitSuccess && state.units.length > 0) {
            final List<Unit> units = state.units;
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final Unit unit = units[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              AudioBloc(repository: _listeningRepository),
                          child: AudioListScreen(
                            id: unit.id,
                          ),
                        ),
                      ),
                    ),
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.28),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            unit.unit,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) => Container(
                padding: EdgeInsets.only(top: 8),
              ),
              itemCount: units.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
