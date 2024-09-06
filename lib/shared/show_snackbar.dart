import 'package:flutter/material.dart';
import 'package:leaderboard_application/application.dart';

void showSnackbar(String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(message),
  ));
}
