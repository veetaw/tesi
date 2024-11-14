import 'package:flutter/material.dart';

class AskQuizHog extends StatelessWidget {
  static const String routeName = "ask_quizhog";
  const AskQuizHog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizHog"),
      ),
      body: Placeholder(),
    );
  }
}
