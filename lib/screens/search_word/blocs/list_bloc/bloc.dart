import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';

class ListBloc extends Bloc<SearchEvent, ListState> {
  final ListRepository repository;

  ListBloc({this.repository})
      : assert(repository != null),
        super(ListInitial());

  @override
  Stream<ListState> mapEventToState(SearchEvent event) async* {
    final currentState = state;
    if (event is SearchWord) {
      try {
        if (currentState is ListInitial ||
            (event.isRefresh != null && event.isRefresh)) {
          final words = await repository.searchWord(
              startIndex: 0, limit: 20, keyword: event.keyword);
          print('go');
          yield ListSuccess(
            words: words,
            hasReachedMax: false,
          );
          return;
        }
        if (currentState is ListSuccess && (event.isRefresh == null || !event.isRefresh) && !_hasReachMax(currentState)) {
          final words = await repository.searchWord(
              startIndex: currentState.words.length,
              limit: 20,
              keyword: event.keyword);
          print(words);
          yield words.isEmpty
              ? ListSuccess(
                  words: currentState.words,
                  hasReachedMax: true,
                )
              : ListSuccess(
                  words: currentState.words + words,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        yield ListFailure();
      }
    }
  }

  bool _hasReachMax(state) => state is ListSuccess && state.hasReachedMax;
}
