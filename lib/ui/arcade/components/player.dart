import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
}

class Player {
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect playerRect;
  Sprite playerSprite;
  bool isDead = false;

  Player(this.gameController) {
    maxHealth = currentHealth = 300;
    final size = gameController.tileSize * 3;
    playerSprite = Sprite('chip.png');
    playerRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - size / 2,
      gameController.screenSize.height / 2 - size / 2,
      size,
      size,
    );
  }

  void render(Canvas c) {
    playerSprite.renderRect(c, playerRect);
  }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }
}
