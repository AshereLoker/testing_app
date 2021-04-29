import 'dart:async';

import 'package:awesome_authentication_app/data/models/confirmed_password_model.dart';
import 'package:awesome_authentication_app/data/models/password_model.dart';
import 'package:awesome_authentication_app/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'password_update_event.dart';
part 'password_update_state.dart';

class PasswordUpdateBloc
    extends Bloc<PasswordUpdateEvent, PasswordUpdateState> {
  PasswordUpdateBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(PasswordUpdateState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<PasswordUpdateState> mapEventToState(
    PasswordUpdateEvent event,
  ) async* {
    if (event is PasswordUpdateNewPasswordChanged) {
      yield _mapNewPasswordChangedToState(event, state);
    } else if (event is PasswordUpdateConfirmedPasswordChanged) {
      yield _mapConfirmedChangedUpdatedToState(event, state);
    } else if (event is PasswordUpdateSubmitted) {
      yield* _mapPasswordUpdateSubmittedToState(event, state);
    }
  }

  PasswordUpdateState _mapNewPasswordChangedToState(
    PasswordUpdateNewPasswordChanged event,
    PasswordUpdateState state,
  ) {
    final newPassword = PasswordModel.dirty(event.newPassword);
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: newPassword.value,
      value: state.confirmedPassword.value,
    );
    return state.copyWith(
      password: newPassword,
      confirmedPassword: confirmedPassword,
      status: Formz.validate([newPassword, state.confirmedPassword]),
    );
  }

  PasswordUpdateState _mapConfirmedChangedUpdatedToState(
    PasswordUpdateConfirmedPasswordChanged event,
    PasswordUpdateState state,
  ) {
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: state.newPassword.value,
      value: event.confirmedPassword,
    );
    return state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate([confirmedPassword, state.newPassword]),
    );
  }

  Stream<PasswordUpdateState> _mapPasswordUpdateSubmittedToState(
    PasswordUpdateSubmitted event,
    PasswordUpdateState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository
            .updatePassword(newPassword: state.newPassword.value)
            .timeout(Duration(seconds: 20), onTimeout: () {
          throw TimeoutException('Update password failure');
        });
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
