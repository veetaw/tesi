import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/model/message.dart';
import 'package:tesi/provider/chat_provider.dart';
import 'package:tesi/screen/quizhog.dart';
import 'package:tesi/service/api.dart';

class AskQuizHog extends ConsumerStatefulWidget {
  static const String routeName = "ask_quizhog";

  final ScreenInput input;

  AskQuizHog({super.key, required this.input});

  @override
  ConsumerState<AskQuizHog> createState() => _AskQuizHogState();
}

class _AskQuizHogState extends ConsumerState<AskQuizHog> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.input.textSelection != null) {
      AwesomeDialog loadingDialog = AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.bottomSlide,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadingDialog.show();
      });

      ApiService.getExplain(
              widget.input.pdfContent!, widget.input.textSelection ?? "")
          .then((v) {
        ref.read(chatProvider).addMessage(v);
        loadingDialog.dismiss();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    ApiService.closeChat();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

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
                  controller: _scrollController,
                  children: ref.watch(chatProvider).messages.map((message) {
                    return MessageWidget(
                      user: message.user,
                      message: message.messaggio,
                    );
                  }).toList()
                    ..addAll([
                      if (ref.watch(chatProvider).isTyping)
                        const MessageWidget(
                          user: false,
                          message: "QuizHog sta scrivendo...",
                        ),
                    ]),
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
                            ref.read(chatProvider).addMessage(
                                  Message(
                                    messaggio: controller.text,
                                  ),
                                );

                            ref.read(chatProvider).isTyping = true;

                            ApiService.chat(controller.text).then((value) {
                              ref.read(chatProvider).addMessage(value);
                              ref.read(chatProvider).isTyping = false;
                            });

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

class MessageWidget extends StatelessWidget {
  final bool user;
  final String message;

  const MessageWidget({
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
