import 'package:equatable/equatable.dart';

abstract class FlashCardEvent extends Equatable {}

class GetListGroup extends FlashCardEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RenameSeries extends FlashCardEvent {
  final String id;
  final String name;


  RenameSeries({this.id, this.name});

  @override
  // TODO: implement props
  List<Object> get props => [id, name];
}