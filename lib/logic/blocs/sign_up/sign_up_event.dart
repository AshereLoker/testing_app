part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  SignUpEmailChanged({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  SignUpPasswordChanged({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpConfirmedPasswordChanged extends SignUpEvent {
  SignUpConfirmedPasswordChanged({
    required this.confirmedPassword,
  });

  final String confirmedPassword;

  @override
  List<Object> get props => [confirmedPassword];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
