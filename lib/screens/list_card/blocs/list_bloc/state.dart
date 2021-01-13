import 'package:equatable/equatable.dart';
import 'package:pie/models/flashcard_series.dart';

abstract class ListCardState extends Equatable {
  @override
  List<Object> get props {

  }
}
class ListCardInitial extends ListCardState {}
class ListCardLoading extends ListCardState {}
class ListCardSuccess extends ListCardState {
  final FlashCardSeries series;

  ListCardSuccess({this.series});

  @override
  List<Object> get props => [series];
}
class ListCardFailure extends ListCardState {}