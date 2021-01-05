import 'package:equatable/equatable.dart';
import 'package:pie/models/word.dart';

abstract class ListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}
class ListLoading extends ListState {}
class ListSuccess extends ListState {
  final List<Word> words;
  final bool hasReachedMax;

  ListSuccess({this.words, this.hasReachedMax});

  @override
  List<Object> get props => [words, hasReachedMax];
}
class ListFailure extends ListState {}