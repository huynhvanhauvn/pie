import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/level.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/level_bloc/state.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';

class LevelBloc extends Bloc<ListeningEvent, LevelState> {
  final ListeningRepository repository;

  LevelBloc({this.repository})
      : assert(repository != null),
        super(LevelInitial());

  @override
  Stream<LevelState> mapEventToState(ListeningEvent event) async* {
    if (event is GetListLevel) {
      yield LevelLoading();
      try {
        final List<Level> levels = await repository.getListGLevel();
        print(levels);
        yield LevelSuccess(levels: levels);
      } catch (e) {
        yield LevelFailure();
      }
    }
  }
}
