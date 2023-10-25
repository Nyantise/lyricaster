import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyricaster/file_watcher.dart';

class GlobalCatcher extends StatelessWidget {
  final Widget child;

  const GlobalCatcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onDoubleTap: () => appState.switchFocus(),
        child: MouseRegion(
            child: child,
            onEnter: (_) => appState.hover.value = true,
            onExit: (_) => appState.hover.value = false),
      ),
    );
  }
}

var appState = AppStates();

class AppStates extends GetxController {
  RxBool isReady = false.obs;
  //Mouse and Focus
  RxBool hover = false.obs;
  RxBool stayFocused = true.obs;

  //Text Style
  Rx<TextAlign> textAlign = TextAlign.center.obs;
  Map textAlignTypes = {
    0: TextAlign.left,
    1: TextAlign.center,
    2: TextAlign.right,
  };
  int alignState = 1;
  RxDouble textSize = 52.0.obs;

  //Color
  //0x14061bd9
  Rx<int> backgroundColor = 0x14061bd9.obs;
  Rx<int> subcolor = 0xffffffff.obs;
  Rx<int> textColor = 0xffffffff.obs;

  void changeAlign(int val) async {
    if ((alignState == 0 && val == -1) || (alignState == 2 && val == 1)) {
      return;
    }
    alignState += val;
    textAlign.value = textAlignTypes[alignState];
    await updateConfig();
  }

  void changeSize(int val) async {
    textSize.value += val;
    await updateConfig();
  }

  void switchFocus() {
    stayFocused.value = !stayFocused.value;
  }

  //JSON
  toJson() {
    return {
      'text': {'textSize': textSize.value, 'alignState': alignState},
      'colors': {
        'backgroundColor': backgroundColor.value,
        'subcolor': subcolor.value,
        'textColor': textColor.value
      }
    };
  }

  void fromYaml(Map conf) {
    var text = conf['text'];
    textSize.value = text['textSize'];
    textAlign.value = textAlignTypes[text['alignState']];

    var colors = conf['colors'];
    backgroundColor.value = colors['backgroundColor'];
    subcolor.value = colors['subcolor'];
    textColor.value = colors['textColor'];
  }

  updateConfig() async {
    await yamlWrite(configFile, appState.toJson());
    return true;
  }
}

isColorDark(Color myColor) {
  int g = myColor.green;
  int b = myColor.blue;
  int r = myColor.red;

  double grayscale = (0.299 * r) + (0.587 * g) + (0.114 * b);
  if (grayscale > 128) {
    // color is light
    return false;
  } else {
    // color is dark
    return true;
  }
}
