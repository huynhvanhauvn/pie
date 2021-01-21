import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/flash_card/blocs/copy_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/delete_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';

class CopyGroupBloc extends Bloc<FlashCardEvent, CopyGroupState> {
  final FlashCardRepository repository;

  CopyGroupBloc({this.repository})
      : assert(repository != null),
        super(CopyGroupInitial());

  @override
  Stream<CopyGroupState> mapEventToState(FlashCardEvent event) async* {
    if (event is CopySeries) {
      yield CopyGroupLoading();
      try {
        final bool success = await repository.copySeries(
          id: event.id,
        );
        if (success) {
          yield CopyGroupSuccess();
        } else {
          yield CopyGroupFailure();
        }
      } catch (e) {
        yield CopyGroupFailure();
      }
    }
  }
}
