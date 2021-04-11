import 'package:equatable/equatable.dart';

class Unit extends Equatable {
  final String id;
  final String unit;
  final String picture;

  Unit({this.id, this.unit, this.picture});

  @override
  // TODO: implement props
  List<Object> get props => [id, unit, picture];
}
