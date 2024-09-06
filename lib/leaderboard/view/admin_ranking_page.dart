import 'package:flutter/material.dart';
import 'package:leaderboard_application/leaderboard/model/leaderboard_model.dart';
import 'package:leaderboard_application/leaderboard/service/leaderboard_service.dart';

class AdminRankingPage extends StatelessWidget {
  AdminRankingPage({super.key});

  final leaderboardService = LeaderboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Rank Users'),
      ),
      body: StreamBuilder<List<LeaderboardModel>>(
        stream: leaderboardService.getLeaderboardStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Points: ${user.point}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      int? newPoints =
                          await _showEditPointsDialog(context, user.point);
                      if (newPoints != null) {
                        await leaderboardService.updateUserPoints(
                            user.name, newPoints);
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<int?> _showEditPointsDialog(BuildContext context, int currentPoints) {
    TextEditingController controller =
        TextEditingController(text: currentPoints.toString());
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Points'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Points'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(controller.text));
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
