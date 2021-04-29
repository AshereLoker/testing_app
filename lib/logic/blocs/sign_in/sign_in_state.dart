part of 'sign_in_bloc.dart';

@immutable
class SignInState extends Equatable {
  const SignInState({
    this.email = const EmailModel.pure(),
    this.password = const PasswordModel.pure(),
    this.status = FormzStatus.pure,
  });

  final EmailModel email;
  final PasswordModel password;
  final FormzStatus status;

  SignInState copyWith({
    EmailModel email,
    PasswordModel password,
    FormzStatus status,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
