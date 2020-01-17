import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import './game_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

GameController gameController;

class ArcadeGame extends StatefulWidget {
  @override
  _ArcadeGameState createState() => _ArcadeGameState();
}

class _ArcadeGameState extends State<ArcadeGame> {
  void gameStart() async {
    WidgetsFlutterBinding.ensureInitialized();
    Util flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    SharedPreferences storage = await SharedPreferences.getInstance();
    gameController = GameController(storage);
    print("control");
    TapGestureRecognizer tapper = TapGestureRecognizer();
    tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);
    setState(() {
      
    });
  }

  @override
  void initState() {
    gameStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return gameController.widget != null ? gameController.widget : Scaffold();
  }
}
