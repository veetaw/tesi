import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/screen/ask_quizhog.dart';
import 'package:tesi/screen/game.dart';
import 'package:tesi/screen/leaderboard_page.dart';
import 'package:tesi/screen/quizhog.dart';
import 'package:tesi/service/api.dart';

class CoursePage extends StatelessWidget {
  static const String routeName = "course";

  final Course course;

  const CoursePage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.nome),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(LeaderboardPage.routeName, arguments: course);
            },
            icon: const Icon(
              Icons.leaderboard,
              color: kBrownAccent,
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBrownLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medagliere",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            AssetNames.kHandsInPocketSad,
                          ),
                        ),
                        if (course.getLastCompletedLevel()!.livello! <
                            2) // 0, 1

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Sembra tu non abbia ancora delle medaglie",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        else
                          ...getMedals()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                              arguments: ScreenInput(corso: course),
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
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Game.routeName,
                          arguments: course,
                        );
                      },
                      child: Text(
                        'Gioca!',
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
          )
        ],
      ),
    );
  }

  List<Widget> getMedals() {
    List<Widget> medals = [];

    if (course.getLastCompletedLevel()!.livello! >= 2) {
      medals.add(Expanded(child: SvgPicture.asset(AssetNames.kBronze)));
    }
    if (course.getLastCompletedLevel()!.livello! >= 4) {
      medals.add(Expanded(child: SvgPicture.asset(AssetNames.kSilver)));
    }
    if (course.getLastCompletedLevel()!.livello! >= 9) {
      medals.add(Expanded(child: SvgPicture.asset(AssetNames.kGold)));
    }

    return medals;
  }
}
