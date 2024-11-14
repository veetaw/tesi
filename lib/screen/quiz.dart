import 'package:flutter/material.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/level.dart';
import 'package:tesi/model/multiple_choice.dart';

class Quiz extends StatefulWidget {
  static const String routeName = "quiz";
  final Level level;
  const Quiz({super.key, required this.level});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int currentPage = 0;
  List<dynamic> questions = [];

  @override
  void initState() {
    questions = [
      ...widget.level.multipleChoice!,
      ...widget.level.openQuestions!,
    ]..shuffle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < questions.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 5),
                        width: i == currentPage ? 20 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: i == currentPage ? kBrownAccent : kBrownLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PageView.builder(
                onPageChanged: (index) => setState(() => currentPage = index),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  if (questions[index] is MultipleChoice) {
                    MultipleChoice question =
                        questions[index] as MultipleChoice;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          question.question!,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        for (var ans in question.answers!)
                          Row(
                            children: [
                              Checkbox(
                                value: question.answer ==
                                    question.answers!.indexOf(ans),
                                onChanged: (v) {
                                  question.answer =
                                      question.answers!.indexOf(ans);
                                  setState(() {});
                                },
                                activeColor: kBrownLight,
                                checkColor: kBrownAccent,
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                    color: kBrownAccent,
                                    width: 1,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Text(ans),
                            ],
                          )
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                (questions[index]),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 16)),
                          Expanded(
                            child: SingleChildScrollView(
                              child: TextField(
                                maxLines: null,
                                minLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'Inserisci la tua risposta',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kBrownAccent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kBrownAccent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                textAlignVertical: TextAlignVertical.top,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 64, top: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: kBrownLight,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // TODO: ASK API IF OK, IF OK THEN NEXT PAGE AND SHOW ANIMATION
                              },
                              child: Text(
                                'Avanti',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
