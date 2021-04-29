import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:test_app/data/models/email_model.dart';
import 'package:test_app/data/models/password_model.dart';
import 'package:test_app/data/repositories/authentication_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignInState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is SignInPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignInSubmitted) {
      yield* _mapSignInSubmittedToState(event, state);
    } else if (event is SignInWithFacebookSubmitted) {
      yield* _mapSignInWithFacebookSubmittedToState(event, state);
    }
  }

  SignInState _mapEmailChangedToState(
    SignInEmailChanged event,
    SignInState state,
  ) {
    final email = EmailModel.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    );
  }

  SignInState _mapPasswordChangedToState(
    SignInPasswordChanged event,
    SignInState state,
  ) {
    final password = PasswordModel.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    );
  }

  Stream<SignInState> _mapSignInWithFacebookSubmittedToState(
    SignInWithFacebookSubmitted event,
    SignInState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await _authenticationRepository
          .signInWithFacebook()
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException('Sign In with Facebook Exception');
      });
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    } on Exception catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }

  Stream<SignInState> _mapSignInSubmittedToState(
    SignInSubmitted event,
    SignInState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository
            .signInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        )
            .timeout(Duration(seconds: 20), onTimeout: () {
          throw TimeoutException('Sign In Firebase Exception');
        });
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
