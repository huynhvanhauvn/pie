import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';

class DeleteGroupBloc extends Bloc<FlashCardEvent, DeleteGroupState> {
  final FlashCardRepository repository;

  DeleteGroupBloc({this.repository})
      : assert(repository != null),
        super(DeleteGroupInitial());

  @override
  Stream<DeleteGroupState> mapEventToState(FlashCardEvent event) async* {
    if (event is DeleteSeries) {
      yield DeleteGroupLoading();
      try {
        final bool success = await repository.deleteSeries(
          id: event.id,
        );
        if (success) {
          yield DeleteGroupSuccess();
        } else {
          yield DeleteGroupFailure();
        }
      } catch (e) {
        yield DeleteGroupFailure();
      }
    }
  }
}
