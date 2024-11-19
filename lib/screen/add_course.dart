import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/constants/hive.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/service/api.dart';

class AddCourse extends StatefulWidget {
  static const String routeName = "add_course";

  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  Course? selectedCourse;
  List<Course>? _cache;

  Future<List<Course>> getCourses() async {
    _cache ??= await ApiService.getAllCourses();

    return _cache!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Aggiungi corso"),
      ),
      floatingActionButton: selectedCourse != null
          ? FloatingActionButton.extended(
              enableFeedback: true,
              label: Text(
                "Aggiungi",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: kBrownPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              icon: const Icon(Icons.check),
              backgroundColor: kBrownLight,
              foregroundColor: kBrownPrimary,
              onPressed: () async {
                if (selectedCourse == null) {
                  return;
                }
                // get course info
                Course course = await ApiService.getCourseData(selectedCourse!);
                var box = await Hive.openBox<Course>(courseBox);

                // fetch saved courses
                var existingCourses = box.values.toList();
                bool courseExists =
                    existingCourses.any((c) => c.id == course.id);

                if (courseExists) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Course already exists'),
                      ),
                    );
                  }
                  return;
                }

                await box.add(course);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Course added successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: kBrownLight,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Hero(
                tag: AssetNames.kChoosingBook,
                child: SvgPicture.asset(
                  AssetNames.kChoosingBook,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Course>>(
                  future: getCourses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('ERRORE!!\n${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Non ci sono corsi disponibili attualmente',
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Seleziona un corso dalla lista",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (snapshot.data![index] == selectedCourse) {
                                    selectedCourse = null;
                                  } else {
                                    selectedCourse = snapshot.data![index];
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        selectedCourse == snapshot.data![index]
                                            ? kBrownLight
                                            : Colors.transparent,
                                    border: Border.all(
                                      color: kBrownPrimary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    snapshot.data![index].nome,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.length,
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
