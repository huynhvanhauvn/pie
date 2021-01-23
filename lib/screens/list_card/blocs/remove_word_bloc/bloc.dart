import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/list_card/blocs/event.dart';
import 'package:pie/screens/list_card/blocs/remove_word_bloc/state.dart';
import 'package:pie/screens/list_card/blocs/repository.dart';

class RemoveWordBloc extends Bloc<ListCardEvent, RemoveWordState> {
  final ListCardRepository repository;

  RemoveWordBloc({this.repository})
      : assert(repository != null),
        super(RemoveWordInitial());

  @override
  Stream<RemoveWordState> mapEventToState(ListCardEvent event) async* {
    if (event is RemoveWord) {
      yield RemoveWordLoading();
      try {
        final bool success = await repository.removeWord(
          idGroup: event.idGroup,
          idWord: event.idWord,
        );
        if (success) {
          yield RemoveWordSuccess();
        } else {
          yield RemoveWordFailure();
        }
      } catch (e) {
        yield RemoveWordFailure();
      }
    }
  }
}
