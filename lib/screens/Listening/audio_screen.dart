import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie/models/audio.dart';
import 'package:pie/screens/Listening/blocs/audio_detail_bloc/bloc.dart';
import 'package:pie/screens/Listening/blocs/audio_detail_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/widgets/image.dart';
import 'package:pie/widgets/play_button.dart';

class AudioScreen extends StatefulWidget {
  final String id;

  AudioScreen({this.id});

  @override
  State<StatefulWidget> createState() => AudioScreenState();
}

class AudioScreenState extends State<AudioScreen> {
  AudioPlayer audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: 'listening');
  StreamController playStream = StreamController<bool>();
  StreamController durationStream = StreamController<double>();

  Future play(String audio) async {
    int result = await audioPlayer.play(
        'https://englishcommunication.000webhostapp.com/files/audios/${audio}');
    print(result);
    if (result == 1) {
      audioPlayer.onDurationChanged.listen((event) {
        if (event.inMilliseconds > 0) {
          audioPlayer.getDuration().then((value) {
            durationStream.add(value.toDouble());
          });
          playStream.add(true);
        }
      });
    }
  }

  @override
  void initState() {
    BlocProvider.of<AudioDetailBloc>(context).add(GetAudio(id: widget.id));
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<AudioDetailBloc, AudioDetailState>(
        builder: (context, state) {
          if (state is AudioDetailSuccess) {
            final Audio audio = state.audio;
            play(audio.audio);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyImage(
                    url: audio.picture,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    radius: 16,
                  ),
                  Text(audio.audio),
                  StreamBuilder<double>(
                    stream: durationStream.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      final duration = snapshot.data;
                      return StreamBuilder<Duration>(
                          stream: audioPlayer.onAudioPositionChanged,
                          initialData: Duration(milliseconds: 0),
                          builder: (ctx, snap) {
                            final double currentTime =
                                snap.data.inMilliseconds.toDouble();
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat(DateFormat.MINUTE_SECOND)
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    currentTime.toInt())),
                                      ),
                                      Text(
                                        DateFormat(DateFormat.MINUTE_SECOND)
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    duration.toInt())),
                                      ),
                                    ],
                                  ),
                                ),
                                Slider(
                                  value: currentTime,
                                  onChanged: (value) => audioPlayer.seek(
                                      Duration(milliseconds: value.toInt())),
                                  min: 0,
                                  max: duration,
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<bool>(
                        stream: playStream.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final bool isPlaying = snapshot.data;
                            return PlayButton(
                              isPlaying: isPlaying,
                              onPress: () {
                                if (isPlaying) {
                                  audioPlayer.pause();
                                } else {
                                  audioPlayer.resume();
                                }
                                playStream.add(!isPlaying);
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    height: screen.height * 2 / 5,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(audio.script, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(
                            '\n\n...script in Vietnamese\n\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(audio.translate),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
