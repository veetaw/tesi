import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tesi/screen/add_course.dart';
import 'package:tesi/screen/course_page.dart';
import 'package:tesi/screen/home.dart';
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

  // Shared Preferences
  await SharedPreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Home.routeName:
            return MaterialPageRoute(builder: (context) => const Home());
          case AddCourse.routeName:
            return MaterialPageRoute(builder: (context) => const AddCourse());
          case CoursePage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  CoursePage(course: settings.arguments as Course),
            );
          default:
            return MaterialPageRoute(builder: (context) => const LandingPage());
        }
      },
      home: const LandingPage(),
    );
  }
}
