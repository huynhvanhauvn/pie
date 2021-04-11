import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/unit.dart';
import 'package:pie/screens/Listening/blocs/event.dart';
import 'package:pie/screens/Listening/blocs/repository.dart';
import 'package:pie/screens/Listening/blocs/unit_bloc/state.dart';

class UnitBloc extends Bloc<ListeningEvent, UnitState> {
  final ListeningRepository repository;

  UnitBloc({this.repository})
      : assert(repository != null),
        super(UnitInitial());

  @override
  Stream<UnitState> mapEventToState(ListeningEvent event) async* {
    if (event is GetListUnit) {
      yield UnitLoading();
      try {
        final List<Unit> units = await repository.getListUnit(id: event.id);
        print(units);
        yield UnitSuccess(units: units);
      } catch (e) {
        yield UnitFailure();
      }
    }
  }
}
