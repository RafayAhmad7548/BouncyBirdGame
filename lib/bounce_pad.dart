import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum PadType{normal, bouncy, spiky}

class BouncePad extends PositionComponent{

  PadType type = PadType.normal;

  BouncePad({required super.position});

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    size = Vector2(75, 10);

    final random = Random();
    int rnum = random.nextInt(7);
    if(rnum == 0){
      type = PadType.spiky;
    }
    else if(rnum == 1){
      type = PadType.bouncy;
    }


    add(RectangleHitbox());
  }

  @override
  void update(double dt){
    final screenSize = (parent as BouncyBird).size;
    if(position.y > screenSize.y){
      final random = Random();
      final x = random.nextDouble() * ((screenSize.x - 75));
      position.x = x;
      position.y = -10;
    }
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    switch(type){
      case PadType.normal: canvas.drawRect(size.toRect(), Paint()..color = const Color.fromRGBO(255, 255, 255, 1));
      case PadType.bouncy: canvas.drawRect(size.toRect(), Paint()..color = const Color.fromARGB(255, 80, 255, 147));
      case PadType.spiky: canvas.drawRect(size.toRect(), Paint()..color = const Color.fromARGB(255, 255, 74, 74));
    }
  }


}