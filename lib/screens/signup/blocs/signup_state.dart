import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {

  @override
  List<Object> get props => [];
}

class SignupFailure extends SignupState {}
