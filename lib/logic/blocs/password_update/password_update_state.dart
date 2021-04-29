part of 'password_update_bloc.dart';

@immutable
class PasswordUpdateState extends Equatable {
  const PasswordUpdateState({
    this.currentPassword,
    this.password = const PasswordModel.pure(),
    this.confirmedPassword = const ConfirmedPasswordModel.pure(),
    this.status = FormzStatus.pure,
  });

  final String currentPassword;
  final PasswordModel password;
  final ConfirmedPasswordModel confirmedPassword;
  final FormzStatus status;

  PasswordUpdateState copyWith({
    String currentPassword,
    PasswordModel password,
    ConfirmedPasswordModel confirmedPassword,
    FormzStatus status,
  }) {
    return PasswordUpdateState(
      currentPassword: currentPassword ?? this.currentPassword,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props =>
      [currentPassword, password, confirmedPassword, status];
}
