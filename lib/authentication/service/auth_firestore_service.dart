import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:leaderboard_application/authentication/model/user_model.dart';

class AuthFirestoreService {
  final _client = FirebaseFirestore.instance;

  createUser({
    required UserModel userModel,
    bool isAdmin = false,
  }) async {
    try {
      final ref = _client.collection('users').doc(userModel.id);
      return Right(await ref.set(
        userModel.toMap(),
      ));
    } catch (e) {
      return const Left('Something went wrong!');
    }
  }
}
