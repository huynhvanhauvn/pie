import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/audio.dart';
import 'package:pie/screens/Listening/blocs/audio_detail_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';

class AudioDetailBloc extends Bloc<ListeningEvent, AudioDetailState> {
  final ListeningRepository repository;

  AudioDetailBloc({this.repository})
      : assert(repository != null),
        super(AudioDetailInitial());

  @override
  Stream<AudioDetailState> mapEventToState(ListeningEvent event) async* {
    if (event is GetAudio) {
      yield AudioDetailLoading();
      try {
        final Audio audio = await repository.getAudio(
          id: event.id,
        );
        print(audio);
        yield AudioDetailSuccess(audio: audio);
      } catch (e) {
        yield AudioDetailFailure();
      }
    }
  }
}
