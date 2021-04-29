import 'package:awesome_authentication_app/data/models/email_model.dart';
import 'package:awesome_authentication_app/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(
      {@required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(ResetPasswordState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = EmailModel.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> resetPassword() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.resetPassword(email: state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}
