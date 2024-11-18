import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/screen/quizhog.dart';

class AskQuizHog extends StatefulWidget {
  static const String routeName = "ask_quizhog";

  final ScreenInput input;

  AskQuizHog({super.key, required this.input});

  @override
  State<AskQuizHog> createState() => _AskQuizHogState();
}

class _AskQuizHogState extends State<AskQuizHog> {
  final TextEditingController controller = TextEditingController();

  List<Message> history = [
    Message(user: false, message: "Ciaoaoosoaodoaosdoaod"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizHog"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: history,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Scrivi un messaggio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 2,
                        color: kBrownAccent,
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {
                            history.add(
                                Message(user: true, message: controller.text));
                            controller.clear();
                          });
                        }
                      },
                      child: const Icon(
                        Icons.send,
                        color: kBrownAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final bool user;
  final String message;

  const Message({
    super.key,
    required this.user,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment:
            user ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!user) _buildAvatar(user),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: user ? kBrownLight.withAlpha(100) : kBrownLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: Radius.circular(!user ? 12 : 0),
                  bottomRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(user ? 12 : 0),
                ),
              ),
              child: Text(
                message,
                maxLines: null,
              ),
            ),
          ),
          if (user) _buildAvatar(user)
        ],
      ),
    );
  }

  CircleAvatar _buildAvatar(bool user) {
    return CircleAvatar(
      backgroundColor: kBrownLight,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: user
            ? FirebaseAuth.instance.currentUser!.photoURL != null
                ? ClipOval(
                    child: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(AssetNames.kBookInHandWalk),
                  )
            : SvgPicture.asset(
                AssetNames.kBookClosedSideEye,
              ),
      ),
    );
  }
}
