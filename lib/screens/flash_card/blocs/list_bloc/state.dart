import 'package:equatable/equatable.dart';
import 'package:pie/models/flashcard_series.dart';

abstract class ListGroupState extends Equatable {
  @override
  List<Object> get props {

  }
}
class ListGroupInitial extends ListGroupState {}
class ListGroupLoading extends ListGroupState {}
class ListGroupSuccess extends ListGroupState {
  final List<FlashCardSeries> series;

  ListGroupSuccess({this.series});

  @override
  List<Object> get props => [series];
}
class ListGroupFailure extends ListGroupState {}