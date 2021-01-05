import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/user.dart';
import 'package:pie/screens/login/blocs/Login_event.dart';
import 'package:pie/screens/login/blocs/login_repository.dart';
import 'package:pie/screens/login/blocs/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({this.loginRepository}): assert(loginRepository!=null), super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginRequest) {
      yield LoginLoading();
      try {
        final List<String> list = await loginRepository.login(username: event.username, password: event.password);
        yield LoginSuccess(token: list[0], refreshToken: list[1]);
      } catch (e) {
        yield LoginFailure();
      }
    }
  }
}