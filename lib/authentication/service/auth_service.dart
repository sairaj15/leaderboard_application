import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String role, {
    required bool isAdmin,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'role': isAdmin ? 'admin' : 'user',
        'uid': user?.uid,
        'isAdmin': isAdmin,
        'name': 'New User',
        'points': 0,
      });

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<String> getUserRole(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    return snapshot['role'] ?? 'user';
  }
}
