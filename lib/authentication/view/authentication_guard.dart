import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_application/authentication/bloc/auth_bloc.dart';
import 'package:leaderboard_application/authentication/view/auth_screen.dart';
import 'package:leaderboard_application/leaderboard/view/leaderboard_screen.dart';

class AuthenticationGuard extends StatelessWidget {
  const AuthenticationGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return const LeaderboardScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
