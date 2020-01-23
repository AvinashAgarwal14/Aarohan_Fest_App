import 'dart:ui';
import 'dart:math';
import 'package:flame/sprite.dart';

import '../game_controller.dart';

class Enemy {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;
  Sprite enemySprite;
  Sprite damagedEnemy;

  Enemy(this.gameController, double x, double y) {
    health = 2;
    damage = 1;
    speed = gameController.tileSize * 2;
    var enemychoice = Random().nextInt(3);
    if (enemychoice == 0) {
      enemySprite = Sprite('virus.png');
      damagedEnemy = Sprite('virusdamaged.png');
    } else if (enemychoice == 1) {
      enemySprite = Sprite('greenvirus.png');
      damagedEnemy = Sprite('greenvirusdamaged.png');
    } else {
      enemySprite = Sprite('malware.png');
      damagedEnemy = Sprite('malwaredamaged.png');
    }
    enemyRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 2,
      gameController.tileSize * 2,
    );
  }

  void render(Canvas c) {
    switch (health) {
      case 1:
        damagedEnemy.renderRect(c, enemyRect);
        break;
      case 2:
        enemySprite.renderRect(c, enemyRect);
        break;
      default:
        enemySprite.renderRect(c, enemyRect);
        break;
    }
  }

  void update(double t) {
    if (!isDead) {
      double stepDistance = speed * t;
      Offset toPlayer =
          gameController.player.playerRect.center - enemyRect.center;
      if (stepDistance <= toPlayer.distance - gameController.tileSize * 1.25) {
        Offset stepToPlayer =
            Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRect = enemyRect.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  void attack() {
    if (!gameController.player.isDead) {
      gameController.player.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if (gameController.score >
            (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}
