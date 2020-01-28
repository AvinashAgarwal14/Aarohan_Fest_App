import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './game_controller.dart';

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
    setState(() {
      getHelp();
    });
  }

  String help = "false";

  void setHelp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("helpar", "true");
  }

  void getHelp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    help = prefs.getString("helpar");
    print(help);
  }

  Widget instructionsPanel() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFF8EA8C),
            borderRadius: BorderRadius.circular(20.0)),
        child: Scrollbar(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Image.asset("assets/gameicon.png"),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "\nINSTRUCTIONS:\n\n\n💣 click on the grenade twice to destroy it\n\n💣 protect you soldiers from the grenades",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF79462A),
                      fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                color: Color(0xFF79462A),
                child: Text(
                  "PROCEED",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    help = "true";
                    setHelp();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
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
              : help == "false"
                  ? instructionsPanel()
                  : Stack(
                      children: <Widget>[
                        gameController.widget != null
                            ? gameController.widget
                            : Container(),
                        Positioned(
                          top: 40,
                          left: 15,
                          child: IconButton(
                            color: Color(0xFF79462A),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                            ),
                          ),
                        ),
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
