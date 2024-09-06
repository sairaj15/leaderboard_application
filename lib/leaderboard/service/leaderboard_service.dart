import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_application/authentication/model/user_model.dart';
import 'package:leaderboard_application/leaderboard/model/leaderboard_model.dart';

class LeaderboardService {
  final _client = FirebaseFirestore.instance;
  final leaderboardCollection =
      FirebaseFirestore.instance.collection('leaderboard');

  Stream<List<UserModel>> getLeaderboard() {
    return _client
        .collection('users')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updatePoints(String userId, int newPoints) async {
    await _client.collection('users').doc(userId).update({
      'points': newPoints,
    });
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await _client.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Stream<List<LeaderboardModel>> getLeaderboardStream() {
    return leaderboardCollection
        .orderBy('point', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LeaderboardModel(
          image: doc['image'] ?? 'assets/images/default.png',
          name: doc['name'] ?? 'Unnamed',
          rank: doc['rank'] ?? '0',
          point: doc['point'] ?? 0,
        );
      }).toList();
    });
  }

  Future<void> updateUserPoints(String userName, int newPoints) async {
    try {
      log("Updating points for document ID: $userName with new points: $newPoints");
      await leaderboardCollection.doc(userName).update({'point': newPoints});
      log("User points updated successfully for userId: $userName");
      await _updateLeaderboardRanks();
    } catch (e) {
      log("Error updating user points: $e");
      rethrow;
    }
  }

  Future<void> addUserToLeaderboard(
      String userId, String image, String name, String rank, int point) async {
    await _client.collection('leaderboard').doc(userId).set({
      'image': image,
      'name': name,
      'rank': rank,
      'point': point,
    });
  }

  Future<void> _updateLeaderboardRanks() async {
    try {
      final leaderboardSnapshot =
          await leaderboardCollection.orderBy('point', descending: true).get();
      for (int i = 0; i < leaderboardSnapshot.docs.length; i++) {
        final doc = leaderboardSnapshot.docs[i];
        final rank = i + 1;

        await leaderboardCollection.doc(doc.id).update({'rank': rank});
      }
      log("Leaderboard ranks updated successfully");
    } catch (e) {
      log("Error updating leaderboard ranks: $e");
      rethrow;
    }
  }
}
