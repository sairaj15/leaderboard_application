import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leaderboard_application/authentication/model/user_model.dart';
import 'package:leaderboard_application/leaderboard/service/leaderboard_service.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final _leaderboardService = LeaderboardService();

  LeaderboardBloc() : super(LeaderboardState(leaderboard: [])) {
    on<LeaderboardEventLoadLeaderboard>(_onLeaderboardEventLoadLeaderboard);
    on<LeaderboardEventUpdatePoints>(_onLeaderboardEventUpdatePoints);
  }

  FutureOr<void> _onLeaderboardEventLoadLeaderboard(
    LeaderboardEventLoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(
      leaderboard: [],
      isLoading: true,
    ));

    try {
      final leaderboardStream = _leaderboardService.getLeaderboard();
      await emit.forEach<List<UserModel>>(
        leaderboardStream,
        onData: (leaderboard) => state.copyWith(leaderboard: leaderboard),
      );
    } catch (e) {
      emit(state.copyWith(leaderboard: [], error: e.toString()));
    }
  }

  FutureOr<void> _onLeaderboardEventUpdatePoints(
    LeaderboardEventUpdatePoints event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      await _leaderboardService.updatePoints(
        event.userId,
        event.newPoints,
      );
      add(LeaderboardEventLoadLeaderboard());
    } catch (e) {
      emit(state.copyWith(
        leaderboard: state.leaderboard,
        error: e.toString(),
      ));
    }
  }
}
