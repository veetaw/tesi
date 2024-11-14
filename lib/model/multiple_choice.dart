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

  @HiveField(3)
  int? answer;

  @HiveField(4)
  String? spiegazione;

  @HiveField(5)
  String? suggerimento;

  MultipleChoice({this.question, this.answers, this.correctIndex});

  MultipleChoice.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = [json['a'], json['b'], json['c'], json['d']];
    correctIndex = ['a', 'b', 'c', 'd'].indexOf(json['true']);
    answer = json['answer'];
    spiegazione = json['spiegazione'];
    suggerimento = json['suggerimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['a'] = answers?[0];
    data['b'] = answers?[1];
    data['c'] = answers?[2];
    data['d'] = answers?[3];
    data['true'] = answers?[correctIndex ?? 0];
    return data;
  }
}
