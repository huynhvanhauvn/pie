import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/audio.dart';
import 'package:pie/screens/Listening/audio_screen.dart';
import 'package:pie/screens/Listening/blocs/audio_bloc/bloc.dart';
import 'package:pie/screens/Listening/blocs/audio_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/audio_detail_bloc/bloc.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:http/http.dart' as http;
import 'package:pie/screens/Listening/blocs/repository.dart';

class AudioListScreen extends StatefulWidget {
  final String id;

  AudioListScreen({this.id});

  @override
  State<StatefulWidget> createState() => AudioListScreenState();
}

class AudioListScreenState extends State<AudioListScreen> {
  final ListeningRepository _listeningRepository =
      ListeningRepository(httpClient: http.Client());

  @override
  void initState() {
    BlocProvider.of<AudioBloc>(context).add(GetListAudio(idUnit: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state is AudioSuccess && state.audios.length > 0) {
            final List<Audio> audios = state.audios;
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final Audio audio = audios[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              AudioDetailBloc(repository: _listeningRepository),
                          child: AudioScreen(
                            id: audio.id,
                          ),
                        ),
                      ),
                    ),
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          audio.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) => Container(
                padding: EdgeInsets.only(top: 8),
              ),
              itemCount: audios.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
