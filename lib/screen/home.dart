import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/constants/hive.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/screen/add_course.dart';
import 'package:tesi/screen/admin_add.dart';
import 'package:tesi/screen/course_page.dart';
import 'package:tesi/screen/slides.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddCourse.routeName,
          );
        },
        label: Text(
          "Aggiungi corso",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: kBrownAccent,
                fontWeight: FontWeight.w800,
              ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: kBrownLight,
        foregroundColor: kBrownAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CustomAppBar(),
              Expanded(
                child: FutureBuilder(
                    future: Hive.openBox<Course>(courseBox),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Course>(courseBox).listenable(),
                        builder: (context, Box<Course> box, _) {
                          if (box.values.isEmpty) {
                            return Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Hero(
                                    tag: AssetNames.kChoosingBook,
                                    child: SvgPicture.asset(
                                      AssetNames.kChoosingBook,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Non ci sono corsi salvati, inizia aggiungendone uno!',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            var sortedCourses = box.values.toList()
                              ..sort((a, b) {
                                if (a.getProgress() == 1 &&
                                    b.getProgress() != 1) {
                                  return 1;
                                }
                                if (a.getProgress() != 1 &&
                                    b.getProgress() == 1) {
                                  return -1;
                                }
                                return a.updatedOn.compareTo(b.updatedOn);
                              });

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 16),
                              physics: const BouncingScrollPhysics(),
                              itemCount: sortedCourses.length,
                              itemBuilder: (context, index) {
                                Course? course = sortedCourses[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        CoursePage.routeName,
                                        arguments: course,
                                      );
                                    },
                                    child: Dismissible(
                                      direction: DismissDirection.endToStart,
                                      secondaryBackground: const Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.delete,
                                            color: kBrownAccent,
                                          ),
                                        ),
                                      ),
                                      background: Container(),
                                      onDismissed: (direction) =>
                                          box.deleteAt(index),
                                      key: Key(course!.nome),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: kBrownLight.withAlpha(120),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              course.nome,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 16),
                                            ),
                                            if (course.getProgress() != 1) ...[
                                              Text(
                                                "Livello ${course.getLastCompletedLevel()!.livello! + 1}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                              ),
                                              LinearProgressIndicator(
                                                backgroundColor:
                                                    kBrownAccent.withAlpha(50),
                                                color: kBrownAccent,
                                                minHeight: 6,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                value: course.getProgress(),
                                              ),
                                            ] else ...[
                                              Text(
                                                "Corso completato !",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(
                                                width: double.infinity,
                                                height: 10,
                                              ),
                                              SvgPicture.asset(
                                                AssetNames.kDiamond,
                                                width: 100,
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool otherPP = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onHorizontalDragEnd: (_) => setState(
            () => otherPP = !otherPP,
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AdminAddScreen()));
          },
          child: CircleAvatar(
            backgroundColor: kBrownLight,
            radius: 20,
            child:
                FirebaseAuth.instance.currentUser!.photoURL != null && !otherPP
                    ? ClipOval(
                        child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(AssetNames.kBookInHandWalk),
                      ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16),
        ),
        if (FirebaseAuth.instance.currentUser!.displayName != null)
          Expanded(
            child: Text(
              "Ciao ${FirebaseAuth.instance.currentUser!.displayName!}!",
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Slides.routeName);
          },
          icon: const Icon(
            Icons.document_scanner,
          ),
        )
      ],
    );
  }
}
