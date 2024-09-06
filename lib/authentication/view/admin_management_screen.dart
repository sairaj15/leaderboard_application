import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_application/authentication/bloc/auth_bloc.dart';

class AdminManagementScreen extends StatelessWidget {
  AdminManagementScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'User Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                if (email.isNotEmpty) {
                  context.read<AuthBloc>().add(AuthEventCreateAccount(
                        emailAddress: email,
                        password: 'dummyPassword',
                        isAdmin: true,
                      ));
                }
              },
              child: const Text('Promote to Admin'),
            )
          ],
        ),
      ),
    );
  }
}
