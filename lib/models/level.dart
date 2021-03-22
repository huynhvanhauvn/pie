import 'package:equatable/equatable.dart';

class Level extends Equatable {
  final String id;
  final String name;
  final bool allowed;
  final DateTime createDate;
  final String picture;

  Level({this.name, this.allowed, this.id, this.createDate, this.picture});

  @override
  // TODO: implement props
  List<Object> get props => [id, createDate, picture, name, allowed];
}