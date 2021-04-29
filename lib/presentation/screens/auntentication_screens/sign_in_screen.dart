import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/authentication_repository.dart';
import '../../../logic/blocs/sign_in/sign_in_bloc.dart';
import '../../widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  Route route() {
    return MaterialPageRoute(builder: (_) => SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return SignInBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context));
          },
          child: SignInForm(),
        ),
      ),
    );
  }
}
