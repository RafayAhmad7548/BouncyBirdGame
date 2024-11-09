import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(GameWidget(game: BouncyBird()));
}