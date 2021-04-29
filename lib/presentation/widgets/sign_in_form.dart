import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../logic/blocs/sign_in/sign_in_bloc.dart';
import '../screens/auntentication_screens/sign_up_screen.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: const Text('Sign In Failure')));
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
            _SignInButton(),
            const SizedBox(
              height: 8.0,
            ),
            _SignInWithFacebook(),
            const SizedBox(
              height: 8.0,
            ),
            _SignUpButton(),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignInBloc>().add(SignInEmailChanged(email: email)),
          decoration: InputDecoration(
            labelText: 'User email',
            errorText: state.email.invalid ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<SignInBloc>()
              .add(SignInPasswordChanged(password: password)),
          decoration: InputDecoration(
            labelText: 'User password',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (prevState, curState) => prevState.status != curState.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signInForm_continue_elevatedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: const Color(0xFFFFD600),
                ),
                child: const Text('SIGN IN'),
                onPressed: state.status.isValidated
                    ? () => context.read<SignInBloc>().add(SignInSubmitted())
                    : null,
              );
      },
    );
  }
}

class _SignInWithFacebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('signInForm_continueWithFacebook_elevatedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            primary: const Color(0xFFFFD600),
          ),
          child: const Text('FACEBOOK LOGIN'),
          onPressed: () =>
              context.read<SignInBloc>().add(SignInWithFacebookSubmitted()),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
      onPressed: () => Navigator.of(context).push<void>(SignUpScreen.route()),
    );
  }
}
