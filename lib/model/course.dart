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

  Course({
    required this.id,
    required this.nome,
    required this.argomenti,
    this.levels,
  });

  @override
  String toString() {
    return 'Course{id: $id, nome: $nome}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'argomenti': argomenti,
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.nome == nome &&
        other.argomenti == argomenti;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ argomenti.hashCode;
}