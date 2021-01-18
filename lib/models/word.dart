import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final id;
  final word;
  final type;
  final meaning;
  final picture;
  bool selected;

  Word(
      {this.id,
      this.word,
      this.type,
      this.meaning,
      this.picture,
      this.selected = false});

  @override
  String toString() =>
      '{id: ${id}, word: ${word}, type: ${type}, meaning: ${meaning}, picture: ${picture}, selected: ${selected}}';

  Map<String, dynamic> toIdJson() => {
      "id": id
  };

  @override
  // TODO: implement props
  List<Object> get props => [id, word, type, meaning, picture, selected];
}
