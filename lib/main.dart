import 'dart:io';

import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid || Platform.isIOS){
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  runApp(GameWidget(game: BouncyBird()));
}