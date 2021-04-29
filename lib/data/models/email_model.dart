import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

enum EmailValidatorError { invalid }

@immutable
class EmailModel extends FormzInput<String, EmailValidatorError> {
  const EmailModel.pure() : super.pure('');
  const EmailModel.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidatorError validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidatorError.invalid;
  }
}
