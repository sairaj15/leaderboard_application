import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardModel {
  LeaderboardModel({
    required this.image,
    required this.name,
    required this.rank,
    required this.point,
  });

  final String image;
  final String name;
  final int rank;
  final int point;

  factory LeaderboardModel.fromFirestore(DocumentSnapshot doc) {
    return LeaderboardModel(
      image: doc['image'] ?? 'assets/images/default.png',
      name: doc['name'] ?? 'Unnamed',
      rank: doc['rank'] is String
          ? int.parse(doc['rank'] as String)
          : doc['rank'] as int,
      point: doc['point'] is String
          ? int.parse(doc['point'] as String)
          : doc['point'] as int,
    );
  }
}
