import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BouncePad extends PositionComponent{

  BouncePad({required super.position});

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    size = Vector2(75, 10);
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
    canvas.drawRect(size.toRect(), Paint()..color = const Color.fromRGBO(255, 255, 255, 1));
  }


}