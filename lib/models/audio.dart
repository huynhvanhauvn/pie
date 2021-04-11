import 'package:equatable/equatable.dart';

class Audio extends Equatable {
  final String id;
  final String idUnit;
  final String title;
  final String script;
  final String translate;
  final String audio;
  final String picture;

  Audio(
      {this.id,
      this.idUnit,
      this.title,
      this.script,
      this.translate,
      this.audio,
      this.picture});

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, idUnit, title, script, translate, audio, picture];
}
