import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyricaster/file_watcher.dart';
import 'package:lyricaster/app_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LyricsText extends StatefulWidget {
  const LyricsText({super.key});

  @override
  State<LyricsText> createState() => _LyricsTextState();
}

class _LyricsTextState extends State<LyricsText> {
  String hey = 'No Lyrics';
  int noLyricsTimeout = 0;

  @override
  void initState() {
    lyricstify.watch().listen((event) async {
      String newString = await readLastLine();
      setState(() {
        noLyricsTimeout = 0;
        hey = newString.trim() == '' ? '...' : newString;
      });
    });

    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        noLyricsTimeout++;
        if (noLyricsTimeout >= 3) {
          hey = '...';
          if (noLyricsTimeout >= 6) {
            hey = 'No Lyrics';
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: SizedBox(
        width: double.maxFinite,
        child: Obx(
          () => AnimatedDefaultTextStyle(
            style: TextStyle(
              fontSize: appState.textSize.value,
              color: Colors.white,
            ),
            curve: Curves.elasticOut,
            duration: const Duration(milliseconds: 700),
            child: TextAnimator(
              hey,
              characterDelay: const Duration(milliseconds: 8),
              incomingEffect: WidgetTransitionEffects.outgoingScaleUp(
                  duration: const Duration(milliseconds: 100)),
              outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
              textAlign: appState.textAlign.value,
            ),
          ),
        ),
      ),
    );
  }
}
