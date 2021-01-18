import 'package:equatable/equatable.dart';
import 'package:pie/models/word.dart';

abstract class AddWordState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddWordInitial extends AddWordState {}
class AddWordLoading extends AddWordState {}
class AddWordSuccess extends AddWordState {}
class AddWordDuplicated extends AddWordState {}
class AddWordFailure extends AddWordState {}