import 'dart:convert';

class Message {
  bool user;
  String messaggio;
  Map<String, String>? linkApprofondimento;

  Message({
    required this.messaggio,
    this.linkApprofondimento,
    this.user = true,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messaggio: json['messaggio'],
      linkApprofondimento: json['link_approfondimento'] != null
          ? Map<String, String>.from(json['link_approfondimento'])
          : null,
      user: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messaggio': messaggio,
      'link_approfondimento': linkApprofondimento,
    };
  }
}
