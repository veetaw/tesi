import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tesi/model/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  bool _isTyping = false;

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);

    notifyListeners();
  }

  set isTyping(bool isTyping) {
    _isTyping = isTyping;

    notifyListeners();
  }

  bool get isTyping => _isTyping;
}

final chatProvider =
    ChangeNotifierProvider.autoDispose<ChatProvider>((ref) => ChatProvider());
