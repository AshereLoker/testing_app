import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/authentication/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  Route route() {
    return MaterialPageRoute(builder: (_) => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLogoutRequested());
            },
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 4.0),
            CircleAvatar(
              child: Image.network(user.photo),
            ),
            const SizedBox(height: 4.0),
            Text(user.email),
            const SizedBox(height: 4.0),
            Text(user.email),
          ],
        ),
      ),
    );
  }
}
