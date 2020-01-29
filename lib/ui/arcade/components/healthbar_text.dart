import 'package:flutter/material.dart';
import '../game_controller.dart';

class HealthText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  HealthText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    painter.text = TextSpan(
      text: 'HEALTH',
      style: TextStyle(
        color: Color(0xFFF8EA8C),
        fontSize: 50.0,
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.7) - (painter.height / 2),
    );
  }
}
