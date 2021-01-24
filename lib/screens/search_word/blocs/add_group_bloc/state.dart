import 'package:equatable/equatable.dart';

abstract class AddGroupState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddGroupInitial extends AddGroupState {}
class AddGroupLoading extends AddGroupState {}
class AddGroupSuccess extends AddGroupState {}
class AddGroupDuplicated extends AddGroupState {}
class AddGroupFailure extends AddGroupState {}