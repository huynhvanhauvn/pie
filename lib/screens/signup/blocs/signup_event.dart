import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {}

class SignupRequest extends SignupEvent {
  final String username;
  final String password;
  final String fullname;
  final String gender;
  final String birthday;

  SignupRequest(
      {this.username, this.password, this.fullname, this.gender, this.birthday});

  @override
  // TODO: implement props
  List<Object> get props => [username, password, fullname, gender, birthday];
}
