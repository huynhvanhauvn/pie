import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/word.dart';
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
    print('lala start');
    if (event is SearchWord) {
      try {
        print('lala go');
        print(currentState);
        print(event.isRefresh);
        print(_hasReachMax(currentState));
        if (currentState is ListInitial ||
            (event.isRefresh != null && event.isRefresh)) {
          print('lala lac');
          final words = await repository.searchWord(
              startIndex: 0, limit: 20, keyword: event.keyword);
          print('go');
          yield ListSuccess(
            words: words,
            hasReachedMax: false,
          );
          return;
        }
        if (currentState is ListSuccess &&
            (event.isRefresh == null || !event.isRefresh) &&
            !_hasReachMax(currentState)) {
          print('lala');
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
        print(e);
        yield ListFailure();
      }
    } else if (event is SelectWord) {
      if (currentState is ListSuccess) {
        print('handling...');
        final List<Word> copy = List<Word>.from(currentState.words);
        final List<Word> words = copy
            .map((e) => e.id == event.word.id
                ? Word(
                    id: e.id,
                    word: e.word,
                    type: e.type,
                    meaning: e.meaning,
                    picture: e.picture,
                    selected: event.value,
                  )
                : e)
            .toList();
        print('word: ${event.word}, select: ${event.value}');
        print(words);
        yield ListSuccess(words: words, hasReachedMax: currentState.hasReachedMax);
      }
    }
  }

  bool _hasReachMax(state) => state is ListSuccess && state.hasReachedMax;
}
