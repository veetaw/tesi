import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/open_question.dart';
import 'package:tesi/screen/add_course.dart';
import 'package:tesi/screen/ask_quizhog.dart';
import 'package:tesi/screen/course_page.dart';
import 'package:tesi/screen/game.dart';
import 'package:tesi/screen/home.dart';
import 'package:tesi/screen/leaderboard_page.dart';
import 'package:tesi/screen/quiz.dart';
import 'package:tesi/screen/quizhog.dart';
import 'package:tesi/screen/slides.dart';
import 'package:tesi/service/shared_preferences_service.dart';
import 'firebase_options.dart';

import 'package:tesi/model/course.dart';
import 'package:tesi/model/level.dart';
import 'package:tesi/model/multiple_choice.dart';
import 'package:tesi/screen/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive
  Hive.init((await getApplicationDocumentsDirectory()).path);
  Hive.initFlutter();
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(LevelAdapter());
  Hive.registerAdapter(MultipleChoiceAdapter());
  Hive.registerAdapter(OpenQuestionAdapter());

  // Shared Preferences
  await SharedPreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Nunito',
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: kBrownLight.withAlpha(100),
            cursorColor: kBrownAccent,
            selectionHandleColor: kBrownPrimary,
          ),
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Home.routeName:
              return MaterialPageRoute(builder: (context) => const Home());
            case AddCourse.routeName:
              return MaterialPageRoute(builder: (context) => const AddCourse());
            case Slides.routeName:
              return MaterialPageRoute(builder: (context) => const Slides());
            case CoursePage.routeName:
              return MaterialPageRoute(
                builder: (context) =>
                    CoursePage(course: settings.arguments as Course),
              );
            case Game.routeName:
              return MaterialPageRoute(
                builder: (context) =>
                    Game(course: settings.arguments as Course),
              );
            case Quiz.routeName:
              return MaterialPageRoute(
                builder: (context) => Quiz(level: settings.arguments as Level),
              );
            case AskQuizHog.routeName:
              return MaterialPageRoute(
                builder: (context) => AskQuizHog(
                  input: settings.arguments as ScreenInput,
                ),
              );
            case QuizHog.routeName:
              return MaterialPageRoute(
                builder: (context) =>
                    QuizHog(input: settings.arguments as ScreenInput),
              );
            case LeaderboardPage.routeName:
              return MaterialPageRoute(
                builder: (context) =>
                    LeaderboardPage(course: settings.arguments as Course),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const LandingPage(),
              );
          }
        },
        home: const LandingPage(),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
