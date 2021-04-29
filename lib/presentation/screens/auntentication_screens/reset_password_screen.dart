import 'package:awesome_authentication_app/data/repositories/authentication_repository.dart';
import 'package:awesome_authentication_app/logic/cubits/reset_password/reset_password_cubit.dart';
import 'package:awesome_authentication_app/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  Route route() {
    return MaterialPageRoute<void>(builder: (_) => ResetPasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return ResetPasswordCubit(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: ResetPasswordForm(),
        ),
      ),
    );
  }
}
