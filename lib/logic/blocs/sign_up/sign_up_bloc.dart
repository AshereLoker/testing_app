import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import '../../../data/models/confirmed_password_model.dart';
import '../../../data/models/email_model.dart';
import '../../../data/models/password_model.dart';
import '../../../data/repositories/authentication_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(SignUpState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is SignUpPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignUpConfirmedPasswordChanged) {
      yield _mapConfirmedPasswrodChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
      yield* _mapSignUpSubmittedToState(event, state);
    }
  }

  SignUpState _mapEmailChangedToState(
    SignUpEmailChanged event,
    SignUpState state,
  ) {
    final email = EmailModel.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.password, state.confirmedPassword, email]),
    );
  }

  SignUpState _mapPasswordChangedToState(
    SignUpPasswordChanged event,
    SignUpState state,
  ) {
    final password = PasswordModel.dirty(event.password);
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    return state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate([password, state.confirmedPassword, state.email]),
    );
  }

  SignUpState _mapConfirmedPasswrodChangedToState(
    SignUpConfirmedPasswordChanged event,
    SignUpState state,
  ) {
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: state.password.value,
      value: event.confirmedPassword,
    );
    return state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate([confirmedPassword, state.email, state.password]),
    );
  }

  Stream<SignUpState> _mapSignUpSubmittedToState(
    SignUpSubmitted event,
    SignUpState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
