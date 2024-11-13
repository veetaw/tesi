import 'package:hive/hive.dart';
import 'package:tesi/model/multiple_choice.dart';

part 'level.g.dart';

@HiveType(typeId: 2)
class Level extends HiveObject {
  @HiveField(0)
  int? livello;

  @HiveField(1)
  List<String>? openQuestions;

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
    print(livello);
    openQuestions = json['open_questions'].cast<String>();
    if (json['multiple_choice'] != null) {
      multipleChoice = <MultipleChoice>[];
      json['multiple_choice'].forEach((v) {
        multipleChoice!.add(MultipleChoice.fromJson(v));
      });
    }

    print(this);
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
}