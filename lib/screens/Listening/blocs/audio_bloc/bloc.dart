import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/audio.dart';
import 'package:pie/screens/Listening/blocs/audio_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';

class AudioBloc extends Bloc<ListeningEvent, AudioState> {
  final ListeningRepository repository;

  AudioBloc({this.repository})
      : assert(repository != null),
        super(AudioInitial());

  @override
  Stream<AudioState> mapEventToState(ListeningEvent event) async* {
    if (event is GetListAudio) {
      yield AudioLoading();
      try {
        final List<Audio> audios = await repository.getListAudio(
          idUnit: event.idUnit,
          idLevel: event.idLevel,
        );
        print(audios);
        yield AudioSuccess(audios: audios);
      } catch (e) {
        yield AudioFailure();
      }
    }
  }
}
