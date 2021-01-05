import 'package:equatable/equatable.dart';
import 'package:pie/models/word.dart';

class FlashCardSeries extends Equatable {
  final id;
  final title;
  final idUser;
  final createDate;
  final length;
  final List<Word> words;

  FlashCardSeries({this.id, this.title, this.words, this.idUser, this.createDate, this.length});

  @override
  // TODO: implement props
  List<Object> get props => [id,title, words, idUser, createDate, length];
}
