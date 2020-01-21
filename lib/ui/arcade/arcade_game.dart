import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import './game_controller.dart';

import './state.dart';

// GameController gameController;

class ArcadeGame extends StatefulWidget {
  GameController gameController;
  ArcadeGame(this.gameController);
  @override
  _ArcadeGameState createState() => _ArcadeGameState(gameController);
}

class _ArcadeGameState extends State<ArcadeGame> {
  GameController gameController;
  _ArcadeGameState(this.gameController);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light));
        Navigator.pop(context);
      },
      child: Scaffold(
          body: _isLoading
              ? LinearProgressIndicator()
              : Stack(
                  children: <Widget>[
                    gameController.widget != null
                        ? gameController.widget
                        : Container(),
                    // gameController.state == States.menu
                    //     ? Positioned(
                    //         bottom: 30,
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(horizontal: 20),
                    //           child: Text(
                    //             "HEALTH",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.grey,
                    //                 fontSize: 18,
                    //                 shadows: [
                    //                   BoxShadow(
                    //                       color: Colors.grey.withOpacity(0.9),
                    //                       offset: Offset(2, 2),
                    //                       blurRadius: 5,
                    //                       spreadRadius: 5)
                    //                 ]),
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                )),
    );
  }
}
