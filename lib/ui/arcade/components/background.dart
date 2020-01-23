import 'dart:ui';
import 'package:flame/sprite.dart';
import '../game_controller.dart';

class Background {
  final GameController gameController;
  Rect bgRect;
  Sprite bgSprite;

  Background(this.gameController) {
    bgSprite = Sprite('gamebackground.jpg');
    bgRect = Rect.fromLTWH(0, 0, gameController.screenSize.width,
        gameController.screenSize.height);
  }

  void render(Canvas c) {
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {}
}
