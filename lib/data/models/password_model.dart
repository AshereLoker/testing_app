import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

enum PasswordValidationError { invalid }

@immutable
class PasswordModel extends FormzInput<String, PasswordValidationError> {
  const PasswordModel.pure() : super.pure('');
  const PasswordModel.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}
