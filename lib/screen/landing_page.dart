import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/service/google_auth.dart';

import 'package:tesi/service/shared_preferences_service.dart';

class LandingPage extends StatelessWidget {
  static const String routeName = "landing_page";
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: SvgPicture.asset(
                  AssetNames.kHandsInPocketHappy,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "QuizHog",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  Text(
                    "Scopri il tuo potenziale con QuizHog! Impara, gioca e migliora le tue conoscenze attraverso quiz interattivi e sfide divertenti",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: _AnimatedBorderButton(
                  text: GoogleAuth.instance.isUserLoggedIn()
                      ? "Avanti"
                      : "Accedi",
                  onTap: () async {
                    if (GoogleAuth.instance.isUserLoggedIn()) {
                    } else {
                      try {
                        await GoogleAuth.instance.signInWithGoogle();

                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Scaffold(),
                            ),
                          );
                        }
                        return;
                      } catch (e) {
                        if (context.mounted) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            title: 'Errore',
                            desc: 'Errore durante la fase di accesso',
                          ).show();
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBorderButton extends StatefulWidget {
  final Function onTap;
  final String text;

  const _AnimatedBorderButton({required this.onTap, required this.text});

  @override
  _AnimatedBorderButtonState createState() => _AnimatedBorderButtonState();
}

class _AnimatedBorderButtonState extends State<_AnimatedBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => widget.onTap(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: kBrown.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
                    gradient: SweepGradient(
                      startAngle: 0.0,
                      endAngle: 6.28,
                      colors: [
                        kBrown,
                        kBrown.withOpacity(0.1),
                        kBrown.withOpacity(0.1),
                        kBrown,
                      ],
                      stops: [
                        _controller.value - 0.2,
                        _controller.value,
                        _controller.value + 0.2,
                        _controller.value + 0.4,
                      ],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        widget.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
