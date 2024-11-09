import 'dart:async';
import 'dart:math';

import 'package:bouncybird/bird.dart';
import 'package:bouncybird/bounce_pad.dart';
import 'package:flame/game.dart';

class BouncyBird extends FlameGame with HasCollisionDetection{

	late Bird bird;
  late List<BouncePad> bouncePads;

	@override
	FutureOr<void> onLoad() async{
		await super.onLoad();
		bird = Bird(size: Vector2(50, 50));
		bird.position = (size - bird.size) / 2;

    bouncePads = List.generate(7, (index){
      final double step = ((size.y) - 150) / 6;
      final random = Random();
      final x = random.nextDouble() * ((size.x - 75));
      final y = 150 + index * step;
      return BouncePad(position: Vector2(x, y));
    },growable: false);

    addAll(bouncePads);
		add(bird);

	}

	@override
	void update(double dt){
		super.update(dt);
    if(!(bird.position.y > size.y/2 || bird.velocity.y > 0)){
      for(BouncePad bp in bouncePads){
        bp.position.y += -bird.velocity.y;
      }
    }
	}


}