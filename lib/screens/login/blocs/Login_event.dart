import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginRequest extends LoginEvent {
  final String username;
  final String password;

  LoginRequest({this.username, this.password})
      : assert(username != null, password != null);

  @override
  // TODO: implement props
  List<Object> get props => [username, password];
}
