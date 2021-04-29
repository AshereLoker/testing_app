import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_authentication_app/logic/blocs/sign_up/sign_up_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign Up Failure')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const SizedBox(
              height: 8.0,
            ),
            _PasswordInput(),
            const SizedBox(
              height: 8.0,
            ),
            _ConfirmedPasswordInput(),
            const SizedBox(
              height: 8.0,
            ),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email: email)),
          decoration: InputDecoration(
            labelText: 'User email',
            errorText: state.email.invalid ? 'Invalid email to register' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<SignUpBloc>()
              .add(SignUpPasswordChanged(password: password)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmedPassword) => context.read<SignUpBloc>().add(
              SignUpConfirmedPasswordChanged(
                  confirmedPassword: confirmedPassword)),
          decoration: InputDecoration(
            labelText: 'Confirm password',
            errorText: state.confirmedPassword.invalid
                ? 'Password do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (prevState, curState) => prevState.status != curState.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<SignUpBloc>().add(const SignUpSubmitted());
                      }
                    : null,
                child: const Text('Sign Up'),
              );
      },
    );
  }
}
