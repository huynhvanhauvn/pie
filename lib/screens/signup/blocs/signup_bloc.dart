import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/signup/blocs/signup_event.dart';
import 'package:pie/screens/signup/blocs/signup_repository.dart';
import 'package:pie/screens/signup/blocs/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository repository;

  SignupBloc({this.repository})
      : assert(repository != null),
        super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupRequest) {
      yield SignupLoading();
      try {
        final bool success = await repository.signup(
          username: event.username,
          password: event.password,
          fullname: event.fullname,
          gender: event.gender,
          birthday: event.birthday,
        );
        if (success) {
          yield SignupSuccess();
        } else {
          yield SignupFailure();
        }
      } catch (e) {
        yield SignupFailure();
      }
    }
  }
}
