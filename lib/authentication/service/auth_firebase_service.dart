import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService {
  final _client = FirebaseAuth.instance;

  Future<Either<String, UserCredential>> createAccount({
    required String email,
    required String password,
    required bool isAdmin,
  }) async {
    try {
      final response = await _client.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Something went wrong!');
    }
  }

  Future<Either<String, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Something went wrong!');
    }
  }

  Future<Either<String, void>> logout() async {
    try {
      return Right(await _client.signOut());
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Something went wrong!');
    }
  }
}
