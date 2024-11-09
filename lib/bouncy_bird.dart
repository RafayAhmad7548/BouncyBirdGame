import 'dart:async';
import 'dart:math';

import 'package:bouncybird/bird.dart';
import 'package:bouncybird/bounce_pad.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

enum GameState{running, gameover}

class BouncyBird extends FlameGame with HasCollisionDetection, TapDetector{

	late Bird bird;
  late List<BouncePad> bouncePads;
  GameState gameState = GameState.running;
  late TextComponent _gameOverText;

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

    _gameOverText = TextComponent(
      text: "Game Over",
      position: size/2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 56,
        )
      )
    );
    
    addAll(bouncePads);
		add(bird);

	}

	@override
	void update(double dt){
		super.update(dt);

    if(gameState == GameState.running){
      if(_gameOverText.isMounted){
        remove(_gameOverText);
      }
      if(!(bird.position.y > size.y/2 || bird.velocity.y > 0)){
        for(BouncePad bp in bouncePads){
          bp.position.y += -bird.velocity.y;
        }
      }
      if(bird.position.y + bird.size.y >= size.y){
        for(BouncePad bp in bouncePads){
          bp.position.y += -bird.velocity.y;
        }
      }

      bool flag = true;
      for(BouncePad bp in bouncePads){
        if(bp.position.y > 0){
          flag = false;
        }
      }
      if(flag){
        gameState = GameState.gameover;
      }
    }
    else{
      if(!_gameOverText.isMounted){
        add(_gameOverText);
      }
    }

	}

  @override
  void onTap(){
    super.onTap();
    if(gameState == GameState.gameover){
      gameState = GameState.running;
      bird.position = (size - bird.size) / 2;
      bird.velocity = Vector2(0, 5);
      bird.acceleration = Vector2(0, 0.25);
      for(BouncePad bp in bouncePads){
        bp.position.y = 150 + bouncePads.indexOf(bp) * ((size.y - 150) / 6);
      }
      remove(_gameOverText);
    }
  } 
  


}