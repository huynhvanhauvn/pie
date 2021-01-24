import 'package:equatable/equatable.dart';
import 'package:pie/models/word.dart';

abstract class SearchEvent extends Equatable {}

class SearchWord extends SearchEvent {
  String keyword;
  bool isRefresh;

  SearchWord({this.keyword, this.isRefresh});

  @override
  // TODO: implement props
  List<Object> get props => [keyword, isRefresh];
}

class SelectWord extends SearchEvent {
  final Word word;
  final bool value;

  SelectWord({this.word, this.value});

  @override
  // TODO: implement props
  List<Object> get props => [word, value];
}

class AddWord extends SearchEvent {
  final List<Word> words;
  final String idSeries;

  AddWord({this.words, this.idSeries});

  @override
  // TODO: implement props
  List<Object> get props => [words, idSeries];
}

class AddGroup extends SearchEvent {
  final List<Word> words;
  final String groupName;

  AddGroup({this.words, this.groupName});

  @override
  // TODO: implement props
  List<Object> get props => [words, groupName];
}
