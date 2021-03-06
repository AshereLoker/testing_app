part of 'password_update_bloc.dart';

abstract class PasswordUpdateEvent extends Equatable {
  const PasswordUpdateEvent();

  @override
  List<Object> get props => [];
}

class PasswordUpdateNewPasswordChanged extends PasswordUpdateEvent {
  PasswordUpdateNewPasswordChanged({
    @required this.newPassword,
  });

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

class PasswordUpdateConfirmedPasswordChanged extends PasswordUpdateEvent {
  PasswordUpdateConfirmedPasswordChanged({
    @required this.confirmedPassword,
  });

  final String confirmedPassword;

  @override
  List<Object> get props => [confirmedPassword];
}

class PasswordUpdateSubmitted extends PasswordUpdateEvent {
  const PasswordUpdateSubmitted();
}
