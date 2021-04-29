part of 'password_update_bloc.dart';

@immutable
class PasswordUpdateState extends Equatable {
  const PasswordUpdateState({
    this.newPassword = const PasswordModel.pure(),
    this.confirmedPassword = const ConfirmedPasswordModel.pure(),
    this.status = FormzStatus.pure,
  });

  final PasswordModel newPassword;
  final ConfirmedPasswordModel confirmedPassword;
  final FormzStatus status;

  PasswordUpdateState copyWith({
    PasswordModel password,
    ConfirmedPasswordModel confirmedPassword,
    FormzStatus status,
  }) {
    return PasswordUpdateState(
      newPassword: password ?? this.newPassword,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [newPassword, confirmedPassword, status];
}
