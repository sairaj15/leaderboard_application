import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_application/authentication/bloc/auth_bloc.dart';
import 'package:leaderboard_application/authentication/view/auth_screen.dart';
import 'package:leaderboard_application/leaderboard/model/leaderboard_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<LeaderboardModel>> leaderboardFuture;

  @override
  void initState() {
    super.initState();
    leaderboardFuture = _fetchLeaderboard();
  }

  Future<List<LeaderboardModel>> _fetchLeaderboard() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('point', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => LeaderboardModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Image.asset(
                  "lib/assets/images/leaderboard.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 25,
                  child: Image.asset(
                    "lib/assets/images/line.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: FutureBuilder<List<LeaderboardModel>>(
                future: leaderboardFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error fetching data: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No data available"),
                    );
                  }

                  final leaderboardItems = snapshot.data!;

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: leaderboardItems.length,
                        itemBuilder: (context, index) {
                          final items = leaderboardItems[index];
                          return Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, bottom: 15),
                              child: Row(
                                children: [
                                  Text(
                                    items.rank.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(items.image),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    items.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 25,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const RotatedBox(
                                          quarterTurns: 1,
                                          child: Icon(
                                            Icons.back_hand,
                                            color: Color.fromARGB(
                                                255, 255, 187, 0),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          items.point.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthEventLogout(),
                              );
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
