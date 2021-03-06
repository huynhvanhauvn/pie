import 'package:equatable/equatable.dart';

class Level extends Equatable {
  var level;

  Level({this.level});

  @override
  // TODO: implement props
  List<Object> get props => [level];
}