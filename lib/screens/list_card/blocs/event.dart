import 'package:equatable/equatable.dart';

abstract class ListCardEvent extends Equatable {}

class GetListCard extends ListCardEvent {
  final id;

  GetListCard({this.id});

  @override
  // TODO: implement props
  List<Object> get props => [];
}