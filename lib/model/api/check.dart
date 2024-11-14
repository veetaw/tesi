class Check {
  int voto;
  String soluzione;

  Check({required this.voto, required this.soluzione});

  factory Check.fromJson(Map<String, dynamic> json) {
    return Check(
      voto: json['voto'],
      soluzione: json['soluzione'],
    );
  }
}
