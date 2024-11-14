import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/model/level.dart';
import 'package:tesi/screen/quiz.dart';

class Game extends StatelessWidget {
  static const String routeName = "game";
  final Course course;
  const Game({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1.5;
    var width = MediaQuery.of(context).size.width;

    var livelli = course.levels!;
    if (!livelli.any((e) => e.isNext)) {
      livelli[0].isNext = true;
      try {
        livelli[0].save();
      } catch (_) {}
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: height + 100,
              child: SvgPicture.asset(
                AssetNames.kMap,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        color: kBrownAccent,
                      ),
                      Text(
                        "Indietro",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: kBrownAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: Size(width, height),
              painter: DottedLinePainter(livelli: livelli, height: height),
            ),
            for (var level in livelli)
              Positioned(
                left: (width / 2 - 50) +
                    (level.livello! % 2 == 0
                        ? -20.0 * level.livello!
                        : 20.0 * (level.livello! < 9 ? level.livello! : 8)),
                top: MediaQuery.of(context).padding.top +
                    20.0 +
                    (height / 10 * level.livello!),
                child: LevelIndicator(level: level),
              ),
          ],
        ),
      ),
    );
  }
}

class LevelIndicator extends StatefulWidget {
  const LevelIndicator({
    super.key,
    required this.level,
  });

  final Level level;

  @override
  State<LevelIndicator> createState() => _LevelIndicatorState();
}

class _LevelIndicatorState extends State<LevelIndicator> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isTapped = true),
      onTapUp: (details) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      onTap: () async {
        print(widget.level.toString());
        if (!widget.level.isNext || widget.level.isDone) {
          return;
        }

        Navigator.of(context)
            .pushNamed(Quiz.routeName, arguments: widget.level);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            width: isTapped ? 80 : 100,
            height: isTapped ? 80 : 100,
            widget.level.isDone
                ? AssetNames.kBtnDone2
                : widget.level.isNext
                    ? AssetNames.kBtnActive
                    : AssetNames.kBtnDisabled,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${widget.level.isDone ? "✅ " : ""}Livello ${widget.level.livello! + 1}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final List<Level> livelli;
  final double height;

  DottedLinePainter({required this.livelli, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < livelli.length - 1; i++) {
      final startX = (size.width / 2 - 50) +
          (livelli[i].livello! % 2 == 0
              ? -20.0 * livelli[i].livello!
              : 20.0 * (livelli[i].livello! < 9 ? livelli[i].livello! : 8)) +
          25; // Center of the widget
      final startY = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .padding
              .top +
          20.0 +
          (height / 10 * livelli[i].livello!) +
          25; // Center of the widget
      final endX = (size.width / 2 - 50) +
          (livelli[i + 1].livello! % 2 == 0
              ? -20.0 * livelli[i + 1].livello!
              : 20.0 *
                  (livelli[i + 1].livello! < 9 ? livelli[i + 1].livello! : 8)) +
          25; // Center of the widget
      final endY = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .padding
              .top +
          20.0 +
          (height / 10 * livelli[i + 1].livello!) +
          25; // Center of the widget

      if (livelli[i].isDone &&
          (livelli[i + 1].isDone || livelli[i + 1].isNext)) {
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      } else {
        final path = Path()
          ..moveTo(startX, startY)
          ..lineTo(endX, endY);

        final dashArray = [5.0, 5.0];
        canvas.drawPath(
          dashPath(path, dashArray: dashArray),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Path dashPath(
  Path source, {
  required List<double> dashArray,
}) {
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = 0.0;
    int index = 0;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray[index % dashArray.length];
      if (draw) {
        path.addPath(
          measurePath.extractPath(distance, distance + length),
          Offset.zero,
        );
      }
      distance += length;
      draw = !draw;
      index++;
    }
  }
  return path;
}
