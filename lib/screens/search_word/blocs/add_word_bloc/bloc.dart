import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/search_word/blocs/add_word_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';

class AddWordBloc extends Bloc<SearchEvent, AddWordState> {
  final ListRepository repository;

  AddWordBloc({this.repository})
      : assert(repository != null),
        super(AddWordInitial());

  @override
  Stream<AddWordState> mapEventToState(SearchEvent event) async* {
    if (event is AddWord) {
      yield AddWordLoading();
      try {
        final success = await repository.addWords(idSeries: event.idSeries, words: event.words);
        if (success) {
          yield AddWordSuccess();
        } else {
          yield AddWordDuplicated();
        }
      } catch(e) {
        AddWordFailure();
      }
    }
  }
}
