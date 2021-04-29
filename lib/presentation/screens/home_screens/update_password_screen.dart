import 'package:awesome_authentication_app/data/repositories/authentication_repository.dart';
import 'package:awesome_authentication_app/logic/blocs/password_update/password_update_bloc.dart';
import 'package:awesome_authentication_app/presentation/widgets/password_update_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => UpdatePasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return PasswordUpdateBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: PasswordUpdateForm(),
        ),
      ),
    );
  }
}
