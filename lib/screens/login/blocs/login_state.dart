import 'package:equatable/equatable.dart';
import 'package:pie/models/user.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final String refreshToken;

  LoginSuccess({this.token, this.refreshToken})
      : assert(token != null, refreshToken != null);

  @override
  List<Object> get props => [token, refreshToken];
}

class LoginFailure extends LoginState {}
