import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/screen/ask_quizhog.dart';
import 'package:tesi/service/api.dart';

// state management tipo con ref.watch

class QuizHog extends StatelessWidget {
  static const String routeName = "quizhog";
  final ScreenInput input;

  const QuizHog({
    super.key,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizHog"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  AssetNames.kStudying,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (input.textSelection != null &&
                        input.textSelection!.isNotEmpty) ...[
                      Text(
                        "Testo selezionato",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            "\"${(input.textSelection ?? "").replaceAll("\n", " ")}\"",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.white,
                          foregroundColor: kBrownPrimary,
                          side: const BorderSide(color: kBrownPrimary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                                AskQuizHog.routeName,
                                arguments: input,
                              )
                              .then((_) => ApiService.closeChat());
                        },
                        child: Text(
                          'Chiedi a QuizHog',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: kBrownLight,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Quiz!',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScreenInput {
  final String? textSelection;
  final File? pdfContent;
  final Course? corso;

  ScreenInput({
    this.textSelection,
    this.pdfContent,
    this.corso,
  });
}
