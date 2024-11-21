class Leaderboard {
  int courseId;
  String nome;
  int punteggio;

  Leaderboard({
    required this.courseId,
    required this.nome,
    required this.punteggio,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      courseId: json['course_id'],
      nome: json['nome'],
      punteggio: json['punteggio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'nome': nome,
      'punteggio': punteggio,
    };
  }
}
