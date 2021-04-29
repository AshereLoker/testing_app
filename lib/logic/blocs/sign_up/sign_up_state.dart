part of 'sign_up_bloc.dart';

@immutable
class SignUpState extends Equatable {
  SignUpState({
    this.email = const EmailModel.pure(),
    this.password = const PasswordModel.pure(),
    this.confirmedPassword = const ConfirmedPasswordModel.pure(),
    this.status = FormzStatus.pure,
  });
  final EmailModel email;
  final PasswordModel password;
  final ConfirmedPasswordModel confirmedPassword;
  final FormzStatus status;

  SignUpState copyWith({
    EmailModel email,
    PasswordModel password,
    ConfirmedPasswordModel confirmedPassword,
    FormzStatus status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, confirmedPassword, status];
}
