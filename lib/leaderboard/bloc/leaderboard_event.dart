part of 'leaderboard_bloc.dart';

class LeaderboardEvent {}

class LeaderboardEventLoadLeaderboard extends LeaderboardEvent {}

class LeaderboardEventUpdatePoints extends LeaderboardEvent {
  LeaderboardEventUpdatePoints({
    required this.userId,
    required this.newPoints,
  });

  final String userId;
  final int newPoints;
}
