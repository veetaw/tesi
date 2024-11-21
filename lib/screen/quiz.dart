import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      ...widget.level.multipleChoice ?? [],
      ...widget.level.openQuestions ?? [],
    ]..shuffle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.livello != null
            ? "Livello ${widget.level.livello! + 1}"
            : "Quiz"),
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
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
                      return ListView(
                        children: [
                          Text(
                            question.question!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
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
                            child: _buildBtn(
                              context,
                              () async {
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
                                } else {
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.bottomSlide,
                                    title: 'Risposta sbagliata',
                                    body: Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Markdown(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        data:
                                            """**La risposta corretta era**: ${question.answers![question.correctIndex!]}\n**Spiegazione:** ${question.spiegazione}""",
                                      ),
                                    ),
                                  ).show();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  ((questions[index] as OpenQuestion).domanda!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 16)),
                              TextField(
                                controller: _answerController,
                                maxLines: null,
                                minLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'Inserisci la tua risposta',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: kBrownAccent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: kBrownAccent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                textAlignVertical: TextAlignVertical.top,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildBtn(
                                  context,
                                  () async {
                                    AwesomeDialog loadingDialog = AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.bottomSlide,
                                      body: Container(
                                        padding: const EdgeInsets.all(16),
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                    );
                                    loadingDialog.show();

                                    Check resp = await ApiService.checkAnswer(
                                      (questions[index] as OpenQuestion)
                                          .domanda!,
                                      _answerController.text,
                                    );

                                    loadingDialog.dismiss();

                                    questions[index].voto = resp.voto;

                                    await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.bottomSlide,
                                      title:
                                          'Hai ricevuto un voto di ${resp.voto}/30',
                                      desc: resp.soluzione,
                                    ).show();

                                    _answerController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, Function onTap) {
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
          // RISPOSTA MULTIPLA
          int correct = questions
              .where((q) => q is MultipleChoice && q.answer == q.correctIndex)
              .length;

          // RISPOSTA APERTA
          int _total = questions
              .whereType<OpenQuestion>()
              .fold(0, (prev, p) => p.voto! + prev);

          double mean = _total / questions.whereType<OpenQuestion>().length;

          // TOTALE
          int points = questions.fold(0, (prev, q) {
            if (q is MultipleChoice) {
              if (q.answer == q.correctIndex) {
                return prev + 3;
              }
            } else {
              if (q is OpenQuestion) {
                return prev + q.voto!;
              }
            }
            return prev;
          });

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            dismissOnTouchOutside: false,
            title: 'Congratulazioni',
            desc:
                'Hai completato il quiz!\nHai risposto a $correct domande giuste ${widget.level.openQuestions != null ? 'e hai ottenuto una media del ${mean.toStringAsFixed(2)}/30 ${mean >= 25 ? ', FANTASTICO!' : '.'}\nPUNTEGGIO TOTALIZZATO: $points' : '.'}',
            btnOkOnPress: () async {
              widget.level.isDone = true;
              Navigator.of(context).pop<int>(points);
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
