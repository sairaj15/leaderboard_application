part of 'leaderboard_bloc.dart';

class LeaderboardState {
  LeaderboardState({
    required this.leaderboard,
    this.isLoading = false,
    this.error,
  });

  final List<UserModel> leaderboard;
  final bool isLoading;
  final String? error;

  LeaderboardState copyWith({
    List<UserModel>? leaderboard,
    bool? isLoading,
    String? error,
  }) {
    return LeaderboardState(
        leaderboard: leaderboard ?? this.leaderboard,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? error);
  }
}
