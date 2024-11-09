import 'dart:async';
import 'dart:math';

import 'package:bouncybird/bird.dart';
import 'package:bouncybird/bounce_pad.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameState{running, gameover}

class BouncyBird extends FlameGame with HasCollisionDetection, TapDetector{

	late Bird bird;
  late List<BouncePad> bouncePads;
  late TextComponent _gameOverText;
  late TextComponent _scoreText;
  GameState gameState = GameState.running;
  int score = 0;
  int highscore = 0;

  late final SharedPreferencesWithCache prefs;

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
    _scoreText = TextComponent(
      text: "Score: $score HiScore: $highscore",
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
        )
      )
    );

    prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
    highscore = prefs.getInt('hiscore') ?? 0;
    
    addAll(bouncePads);
		add(bird);
    add(_scoreText);

	}

	@override
	void update(double dt) async{
		super.update(dt);

    if(gameState == GameState.running){
      // remove gameover text if there is
      if(_gameOverText.isMounted){
        remove(_gameOverText);
      }

      // increment score
      if(bird.velocity.y < 0){
        score++;
        _scoreText.text = "Score: $score HiScore: $highscore";
      }

      // move pads down i.e. bird moving up
      if(!(bird.position.y > size.y/2 || bird.velocity.y > 0)){
        for(BouncePad bp in bouncePads){
          bp.position.y += -bird.velocity.y;
        }
      }
      // move pads up i.e. bird moving down
      if(bird.position.y + bird.size.y >= size.y){
        for(BouncePad bp in bouncePads){
          bp.position.y += -bird.velocity.y;
        }
      }

      // gameover check
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
      // add gameover text if there isnt
      if(!_gameOverText.isMounted){
        add(_gameOverText);
      }
      if(score > highscore){
        highscore = score;
        _scoreText.text = "Score: $score HiScore: $highscore";
      }
      prefs.setInt('hiscore', highscore);
      score = 0;
      
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