import 'package:flutter/material.dart';
import 'package:leaderboard_application/authentication/view/authentication_guard.dart';
import 'package:leaderboard_application/global_providers.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalProviders(
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: const AuthenticationGuard(),
      ),
    );
  }
}
