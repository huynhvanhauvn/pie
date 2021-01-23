import 'package:equatable/equatable.dart';
import 'package:pie/models/flashcard_series.dart';

abstract class RemoveWordState extends Equatable {
  @override
  List<Object> get props {}
}

class RemoveWordInitial extends RemoveWordState {}

class RemoveWordLoading extends RemoveWordState {}

class RemoveWordSuccess extends RemoveWordState {}

class RemoveWordFailure extends RemoveWordState {}
