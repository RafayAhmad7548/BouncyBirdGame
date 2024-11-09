import 'dart:async';
import 'dart:io';

import 'package:bouncybird/bounce_pad.dart';
import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Bird extends SpriteComponent with CollisionCallbacks{
  Vector2 velocity;
  Vector2 acceleration;
  late Sprite spriteLeft;
  late Sprite spriteRight;
  Bird({required super.size}) : velocity = Vector2(0, 5), acceleration = Vector2(0, 0.25);

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    spriteLeft = await Sprite.load('bird_left.png');
    spriteRight = await Sprite.load('bird_right.png');
    sprite = spriteRight;
    
    if(Platform.isAndroid || Platform.isIOS){
      gyroscopeEventStream().listen((event){
        acceleration.x = event.y/2;
      },);
    }

    add(RectangleHitbox());
  }

  @override
  void update(double dt){ 
    super.update(dt);
    final par = (parent as BouncyBird);
    final screenSize = par.size;

    if(par.gameState == GameState.running){
      // accelarate and move
      velocity.y = velocity.y.clamp(-20, 20);
      if(position.y > screenSize.y/2 || velocity.y > 0){
        position.y += velocity.y;
      }
      position.x += velocity.x;
      velocity.add(acceleration);

      // wrap around the x axis
      if(position.x + size.x < 0){
        position.x = screenSize.x;
      }
      else if(position.x > screenSize.x){
        position.x = -size.x;
      }

      // stop at bottom
      if(position.y + size.y >= screenSize.y){
        position.y = screenSize.y - size.y;
      }

      // make the bird look left and right
      if(velocity.x < 0){
        sprite = spriteLeft;
      }
      else{
        sprite = spriteRight;
      }
    }

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if(velocity.y > 0 /*&& position.y+size.y > other.position.y*/){
      switch((other as BouncePad).type){
        case PadType.normal: velocity.y = -15;
        case PadType.bouncy: velocity.y = -25;
        case PadType.spiky: (parent as BouncyBird).gameState = GameState.gameover;
      }
    }
  }

  void onKeyPress(KeyEvent event){
    if(event is KeyDownEvent){
      switch(event.logicalKey){
        case LogicalKeyboardKey.keyA: velocity.x = -10;
        case LogicalKeyboardKey.keyD: velocity.x = 10;
      }
    }
    else if(event is KeyUpEvent){
      velocity.x = 0;
    }
  }
}