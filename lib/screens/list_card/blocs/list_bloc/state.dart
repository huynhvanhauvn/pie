import 'package:equatable/equatable.dart';
import 'package:pie/models/flashcard_series.dart';

abstract class ListCardState extends Equatable {
  @override
  List<Object> get props {}
}

class ListCardInitial extends ListCardState {}

class ListCardLoading extends ListCardState {}

class ListCardSuccess extends ListCardState {
  final FlashCardSeries series;
  final int position;

  ListCardSuccess({this.series, this.position = 0});

  @override
  List<Object> get props => [series, position];
}

class ListCardFailure extends ListCardState {}
