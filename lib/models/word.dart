import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final id;
  final word;
  final type;
  final meaning;
  final picture;

  Word({this.id, this.word, this.type, this.meaning, this.picture});

  @override
  // TODO: implement props
  List<Object> get props => [id, word, type, meaning, picture];
}
