import 'dart:async';
import 'dart:io';

import 'package:bouncybird/bouncy_bird.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Bird extends SpriteComponent with CollisionCallbacks{
  Vector2 velocity;
  Vector2 acceleration;
  late Sprite spriteLeft;
  late Sprite spriteRight;
  Bird({required super.size}) : velocity = Vector2(0, 5), acceleration = Vector2(0, 0.5);

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
    final screenSize = (parent as BouncyBird).size;

    velocity.y = velocity.y.clamp(-20, 20);

    if(position.y > screenSize.y/2 || velocity.y > 0){
      position.add(velocity);
    }

    velocity.add(acceleration);

    if(position.x + size.x < 0){
      position.x = screenSize.x;
    }
    else if(position.x > screenSize.x){
      position.x = -size.x;
    }
    // if(position.y + size.y < 0){
    //   position.y = screenSize.y;
    // }
    // else if(position.y > screenSize.y){
    //   position.y = -size.y;
    // }

    if(velocity.x < 0){
      sprite = spriteLeft;
    }
    else{
      sprite = spriteRight;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if(velocity.y >= 0){
      velocity.y = -20;
    }
  }


}