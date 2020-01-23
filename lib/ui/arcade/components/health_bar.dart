import 'dart:ui';

import 'package:flutter/material.dart';

import '../game_controller.dart';

class HealthBar {
  final GameController gameController;
  Rect healthBarRect;
  Rect remainingHealthRect;

  HealthBar(this.gameController) {
    double barWidth = gameController.screenSize.width;
    healthBarRect = Rect.fromLTWH(
      // gameController.screenSize.width / 2 - barWidth / 2,
      // gameController.screenSize.height * 0.8,
      // barWidth,
      // gameController.tileSize * 0.5,
      0,
      gameController.screenSize.height - gameController.tileSize * 0.5,
      barWidth,
      gameController.tileSize,
    );
    remainingHealthRect = Rect.fromLTWH(
      // gameController.screenSize.width / 2 - barWidth / 2,
      // gameController.screenSize.height * 0.8,
      // barWidth,
      // gameController.tileSize * 0.5,
      0,
      gameController.screenSize.height - gameController.tileSize * 0.5,
      barWidth,
      gameController.tileSize,
    );
  }

  void render(Canvas c) {
    Paint healthBarColor = Paint()..color = Colors.red;
    Paint remainingBarColor = Paint()..color = Colors.green;
    c.drawRect(healthBarRect, healthBarColor);
    c.drawRect(remainingHealthRect, remainingBarColor);
  }

  void update(double t) {
    double barWidth = gameController.screenSize.width;
    double percentHealth =
        gameController.player.currentHealth / gameController.player.maxHealth;
    remainingHealthRect = Rect.fromLTWH(
      0,
      gameController.screenSize.height - gameController.tileSize * 0.5,
      barWidth * percentHealth,
      gameController.tileSize * 0.5,
    );
  }
}
