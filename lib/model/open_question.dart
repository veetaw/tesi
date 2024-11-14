import 'package:hive/hive.dart';

part 'open_question.g.dart';

@HiveType(typeId: 4)
class OpenQuestion extends HiveObject {
  @HiveField(0)
  String? domanda;

  @HiveField(1)
  String? suggerimento;

  OpenQuestion({this.domanda, this.suggerimento});

  OpenQuestion.fromJson(Map<String, dynamic> json) {
    domanda = json['domanda'];
    suggerimento = json['suggerimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['domanda'] = domanda;
    data['suggerimento'] = suggerimento;
    return data;
  }
}
