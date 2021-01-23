import 'package:equatable/equatable.dart';

abstract class ListCardEvent extends Equatable {}

class GetListCard extends ListCardEvent {
  final id;
  final int position;

  GetListCard({this.id, this.position = 0});

  @override
  // TODO: implement props
  List<Object> get props => [id, position];
}

class RemoveWord extends ListCardEvent {
  final idGroup;
  final idWord;

  RemoveWord({this.idGroup, this.idWord});

  @override
  // TODO: implement props
  List<Object> get props => [idGroup, idWord];
}
