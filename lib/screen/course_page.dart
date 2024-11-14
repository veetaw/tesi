import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/course.dart';

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
      ),
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
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "Sembra tu non abbia ancora delle medaglie",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Placeholder(),
            ),
          )
        ],
      ),
    );
  }
}
