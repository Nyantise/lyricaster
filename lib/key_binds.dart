import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:lyricaster/app_state.dart';

simpleKey(KeyCode _keycode, VoidCallback _action) async {
  var button = HotKey(_keycode, scope: HotKeyScope.inapp);

  await hotKeyManager.register(
    button,
    keyDownHandler: (hkey) => _action(),
  );
}

//Register all Keys
registerKeys() async {
  // directional
  await simpleKey(KeyCode.arrowUp, () => appState.changeSize(2));
  await simpleKey(KeyCode.arrowDown, () => appState.changeSize(-2));
  await simpleKey(KeyCode.arrowLeft, () => appState.changeAlign(-1));
  await simpleKey(KeyCode.arrowRight, () => appState.changeAlign(1));

  // non-combinations
  await simpleKey(KeyCode.keyT, () => print('Text Mode'));
  await simpleKey(KeyCode.keyC, () => print('Color Mode'));
}
