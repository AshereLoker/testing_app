part of 'reset_password_cubit.dart';

@immutable
class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = const EmailModel.pure(),
    this.status = FormzStatus.pure,
  });

  final EmailModel email;
  final FormzStatus status;

  ResetPasswordState copyWith({
    EmailModel email,
    FormzStatus status,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email];
}
