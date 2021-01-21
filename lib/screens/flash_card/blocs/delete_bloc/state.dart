import 'package:equatable/equatable.dart';

abstract class DeleteGroupState extends Equatable {
  @override
  List<Object> get props {

  }
}
class DeleteGroupInitial extends DeleteGroupState {}
class DeleteGroupLoading extends DeleteGroupState {}
class DeleteGroupSuccess extends DeleteGroupState {}
class DeleteGroupFailure extends DeleteGroupState {}