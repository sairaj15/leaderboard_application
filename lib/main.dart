import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_application/application.dart';
import 'package:leaderboard_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Application());
}
