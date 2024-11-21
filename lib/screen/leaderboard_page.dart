import 'package:flutter/material.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/model/leaderboard.dart';
import 'package:tesi/service/api.dart';

class LeaderboardPage extends StatelessWidget {
  static const String routeName = "leaderboard";

  final Course course;

  const LeaderboardPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classifica"),
      ),
      body: FutureBuilder<List<Leaderboard>>(
        future: ApiService.getLeaderboard(course),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text("Errore: ${snapshot.error}"),
            );
          }

          var leaderboard = snapshot.data!;

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              var entry = leaderboard[index];
              return ListTile(
                leading: Text("${index + 1})"),
                title: Text(
                  entry.nome,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: Text(
                  "${entry.punteggio} pt",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
