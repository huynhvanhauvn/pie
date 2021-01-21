import 'package:equatable/equatable.dart';

abstract class CopyGroupState extends Equatable {
  @override
  List<Object> get props {

  }
}
class CopyGroupInitial extends CopyGroupState {}
class CopyGroupLoading extends CopyGroupState {}
class CopyGroupSuccess extends CopyGroupState {}
class CopyGroupFailure extends CopyGroupState {}