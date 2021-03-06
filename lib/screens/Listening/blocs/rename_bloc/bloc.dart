import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/rename_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';

class RenameGroupBloc extends Bloc<FlashCardEvent, RenameGroupState> {
  final FlashCardRepository repository;

  RenameGroupBloc({this.repository}): assert(repository!=null), super(RenameGroupInitial());

  @override
  Stream<RenameGroupState> mapEventToState(FlashCardEvent event) async* {
    if(event is RenameSeries) {
      yield RenameGroupLoading();
      try {
        final bool success = await repository.renameSeries(id: event.id, name: event.name,);
        print(success);
        if (success) {
          yield RenameGroupSuccess();
        } else {
          yield RenameGroupFailure();
        }
      } catch (e) {
        yield RenameGroupFailure();
      }
    }
  }
}