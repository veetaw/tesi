import 'package:hive/hive.dart';
import 'package:tesi/model/multiple_choice.dart';
import 'package:tesi/model/open_question.dart';

part 'level.g.dart';

@HiveType(typeId: 2)
class Level extends HiveObject {
  @HiveField(0)
  int? livello;

  @HiveField(1)
  List<OpenQuestion>? openQuestions;

  @HiveField(2)
  List<MultipleChoice>? multipleChoice;

  @HiveField(3)
  bool isNext = false;

  @HiveField(4)
  bool isDone = false;

  Level(
      {this.livello,
      this.openQuestions,
      this.multipleChoice,
      this.isNext = false,
      this.isDone = false});

  Level.fromJson(Map<String, dynamic> json) {
    livello = json['livello'];
    if (json['open_questions'] != null) {
      openQuestions = <OpenQuestion>[];
      json['open_questions'].forEach((v) {
        openQuestions!.add(OpenQuestion.fromJson(v));
      });
    }
    if (json['multiple_choice'] != null) {
      multipleChoice = <MultipleChoice>[];
      json['multiple_choice'].forEach((v) {
        multipleChoice!.add(MultipleChoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['livello'] = livello;
    data['open_questions'] = openQuestions;
    if (multipleChoice != null) {
      data['multiple_choice'] = multipleChoice!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Level{livello: $livello, openQuestions: $openQuestions, multipleChoice: $multipleChoice, isNext: $isNext, isDone: $isDone}';
  }
}
