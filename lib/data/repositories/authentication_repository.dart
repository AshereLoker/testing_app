import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:test_app/data/models/user_model.dart';

class SignUpFailure implements Exception {}

class SignInWithEmailAndPasswordFailure implements Exception {}

class SignInWithFacebookFailure implements Exception {}

class SignInFirebaseWithFacebookFailure implements Exception {}

class SignOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    FacebookLogin? facebookLogin,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _facebookLogin = facebookLogin ?? FacebookLogin();

  final FirebaseAuth _firebaseAuth;
  final FacebookLogin _facebookLogin;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final result =
          await _facebookLogin.logIn(['email']).timeout(Duration(seconds: 20));
      final credential =
          FacebookAuthProvider.credential(result.accessToken.token);
      await _firebaseAuth
          .signInWithCredential(credential)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw SignInFirebaseWithFacebookFailure();
      });
    } on Exception {
      throw SignInWithFacebookFailure();
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(Duration(seconds: 20));
    } on Exception {
      throw SignInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _facebookLogin.logOut(),
      ]).timeout(Duration(seconds: 10));
    } on Exception {
      throw SignOutFailure();
    }
  }

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
    });
  }
}

extension on User {
  UserModel get toUser {
    return UserModel(
        email: email!, id: uid, name: displayName!, photo: photoURL!);
  }
}