import 'package:hive/hive.dart';
import 'package:tesi/model/level.dart';

part 'course.g.dart';

@HiveType(typeId: 0)
class Course extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  String argomenti;

  @HiveField(3)
  List<Level>? levels;

  @HiveField(4)
  DateTime updatedOn;

  Course({
    required this.id,
    required this.nome,
    required this.argomenti,
    this.levels,
    DateTime? updatedOn,
  }) : updatedOn = updatedOn ?? DateTime.now();

  @override
  String toString() {
    return 'Course{id: $id, nome: $nome, updatedOn: $updatedOn}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'argomenti': argomenti,
      'updatedOn': updatedOn.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    List<Level> levels = [];

    if (json['levels'] != null) {
      json['levels'].forEach((v) {
        levels.add(Level.fromJson(v));
      });
    }

    return Course(
      id: json['id'],
      nome: json['nome'],
      argomenti: json['argomenti'],
      levels: levels,
      updatedOn: DateTime.parse(json['updatedOn']),
    );
  }

  Level? getLastCompletedLevel() {
    if (levels == null) return null;
    return levels!
        .lastWhere((level) => level.isDone, orElse: () => levels!.first);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.nome == nome &&
        other.argomenti == argomenti &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode =>
      id.hashCode ^ nome.hashCode ^ argomenti.hashCode ^ updatedOn.hashCode;

  double getProgress() {
    if (levels == null || levels!.isEmpty) return 0.0;
    Level? lastCompletedLevel = getLastCompletedLevel();
    if (lastCompletedLevel == null) return 0.0;
    return (lastCompletedLevel.livello! + 1) / levels!.length;
  }

  @override
  Future<void> save() async {
    updatedOn = DateTime.now();
    await super.save();
  }
}
