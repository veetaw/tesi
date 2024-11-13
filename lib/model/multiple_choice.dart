import 'package:hive/hive.dart';

part 'multiple_choice.g.dart';

@HiveType(typeId: 3)
class MultipleChoice extends HiveObject {
  @HiveField(0)
  String? question;

  @HiveField(1)
  List<String>? answers;

  @HiveField(2)
  int? correctIndex;

  MultipleChoice({this.question, this.answers, this.correctIndex});

  MultipleChoice.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = [json['a'], json['b'], json['c'], json['d']];
    correctIndex = answers!.indexOf(json['true']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = question;
    data['a'] = answers?[0];
    data['b'] = answers?[1];
    data['c'] = answers?[2];
    data['d'] = answers?[3];
    data['true'] = answers?[correctIndex ?? 0];
    return data;
  }
}
