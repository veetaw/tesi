import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/api/check.dart';
import 'package:tesi/model/level.dart';
import 'package:tesi/model/multiple_choice.dart';
import 'package:tesi/model/open_question.dart';
import 'package:tesi/service/api.dart';

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

  final PageController pageController = PageController();
  final TextEditingController _answerController = TextEditingController();

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
      appBar: AppBar(
        title: Text("Livello ${widget.level.livello! + 1}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark_rounded),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.bottomSlide,
                title: 'Suggerimento',
                desc: questions[currentPage].suggerimento ??
                    'Nessun suggerimento disponibile',
                btnOkOnPress: () {},
              ).show();
            },
          ),
        ],
      ),
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
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
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
                                Expanded(child: Text(ans)),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildBtn(context, () async {
                            print(question.answer == question.correctIndex);
                            if (question.answer == question.correctIndex) {
                              Confetti.launch(
                                context,
                                options: const ConfettiOptions(
                                  particleCount: 200,
                                  spread: 50,
                                  y: 1,
                                  x: 0,
                                ),
                              );
                              Confetti.launch(
                                context,
                                options: const ConfettiOptions(
                                  particleCount: 200,
                                  spread: 50,
                                  y: 1,
                                  x: 1,
                                ),
                              );

                              // wait a bit for the animation
                              await Future.delayed(
                                const Duration(
                                  milliseconds: 500,
                                ),
                              );
                            } else {}
                            try {
                              await question.save();
                            } catch (_) {}
                          }),
                        ),
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
                                ((questions[index] as OpenQuestion).domanda!),
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
                                controller: _answerController,
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
                            child: _buildBtn(
                              context,
                              () async {
                                AwesomeDialog loadingDialog = AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  animType: AnimType.bottomSlide,
                                  body: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                );
                                loadingDialog.show();

                                Check resp = await ApiService.checkAnswer(
                                  (questions[index] as OpenQuestion).domanda!,
                                  _answerController.text,
                                );

                                loadingDialog.dismiss();

                                await AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.bottomSlide,
                                  title:
                                      'Hai ricevuto un voto di ${resp.voto}/30',
                                  desc:
                                      'la risposta corretta era "${resp.soluzione}"',
                                ).show();

                                _answerController.clear();
                              },
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

  ElevatedButton _buildBtn(BuildContext context, Function onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: kBrownLight,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        await onTap();

        if (currentPage + 1 == questions.length) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Congratulazioni',
            desc: 'Hai completato il quiz!',
            btnOkOnPress: () async {
              widget.level.isDone = true;
              try {
                await widget.level.save();
              } catch (_) {}
              Navigator.of(context).pop();
            },
          ).show();
        } else {
          currentPage++;
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          setState(() {});
        }
      },
      child: Text(
        'Avanti',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
