import 'package:equatable/equatable.dart';
import 'package:pie/models/flashcard_series.dart';

abstract class RenameGroupState extends Equatable {
  @override
  List<Object> get props {

  }
}
class RenameGroupInitial extends RenameGroupState {}
class RenameGroupLoading extends RenameGroupState {}
class RenameGroupSuccess extends RenameGroupState {}
class RenameGroupFailure extends RenameGroupState {}