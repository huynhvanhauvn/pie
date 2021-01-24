import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/search_word/blocs/add_group_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/add_word_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/event.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/state.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';

class AddGroupBloc extends Bloc<SearchEvent, AddGroupState> {
  final ListRepository repository;

  AddGroupBloc({this.repository})
      : assert(repository != null),
        super(AddGroupInitial());

  @override
  Stream<AddGroupState> mapEventToState(SearchEvent event) async* {
    if (event is AddGroup) {
      yield AddGroupLoading();
      try {
        final success = await repository.addGroup(groupName: event.groupName, words: event.words);
        if (success) {
          yield AddGroupSuccess();
        } else {
          yield AddGroupDuplicated();
        }
      } catch(e) {
        AddGroupFailure();
      }
    }
  }
}
