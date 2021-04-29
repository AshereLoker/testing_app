import 'package:awesome_authentication_app/logic/blocs/password_update/password_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

var currentPasswordIsValid = false;

class PasswordUpdateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordUpdateBloc, PasswordUpdateState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: const Text('Failure to change password')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NewPasswordInput(),
            const SizedBox(height: 8.0),
            _ConfirmNewPasswordInput(),
            const SizedBox(height: 8.0),
            _PasswordChangeButton()
          ],
        ),
      ),
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordUpdateBloc, PasswordUpdateState>(
      builder: (context, state) {
        return TextField(
          key: const Key('passwordUpdateForm_newPasswordInput_textField'),
          onChanged: (password) => context
              .read<PasswordUpdateBloc>()
              .add(PasswordUpdateNewPasswordChanged(newPassword: password)),
          decoration: InputDecoration(
            labelText: 'New password field',
            errorText:
                state.newPassword.invalid ? 'Invalid password to update' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmNewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordUpdateBloc, PasswordUpdateState>(
      builder: (context, state) {
        return TextField(
          key:
              const Key('passwordUpdateForm_confirmNewPasswordInput_textField'),
          onChanged: (confirmedPassword) => context
              .read<PasswordUpdateBloc>()
              .add(PasswordUpdateConfirmedPasswordChanged(
                  confirmedPassword: confirmedPassword)),
          decoration: InputDecoration(
            labelText: 'Confirm password field',
            errorText: state.confirmedPassword.invalid
                ? 'This password dont match with previous'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordUpdateBloc, PasswordUpdateState>(
      buildWhen: (prevState, curState) => prevState.status != curState.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('passwordUpdateForm_continue_risedButton'),
                onPressed: (state.status.isValidated &&
                        currentPasswordIsValid != false)
                    ? () {
                        context
                            .read<PasswordUpdateBloc>()
                            .add(const PasswordUpdateSubmitted());
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Change password'),
              );
      },
    );
  }
}
