import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class BlackJack extends StatefulWidget {
  var coins_left;
  var fix;
  BlackJack(this.coins_left, this.fix);
  @override
  _BlackJackState createState() => _BlackJackState(coins_left, fix);
}

class _BlackJackState extends State<BlackJack> {
  var coins_left;
  var fix;
  _BlackJackState(this.coins_left, this.fix);

  var card = 'C2';
  var card2 = 'D4';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fcards.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                color: Colors.white.withOpacity(0),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(4.0),
                                padding: EdgeInsets.all(10.0),
                                child: dealerCard(1, 2)),
                          ),
                          Expanded(
                            child: Container(
                                color: Colors.white.withOpacity(0),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(4.0),
                                padding: EdgeInsets.all(10.0),
                                child: playerCard(1, 2)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                    onPressed: () {
                      Navigator.pop(context);
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          statusBarColor: Colors.white,
                          systemNavigationBarIconBrightness: Brightness.dark));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xffff9e80),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Hit() {
    setState(() {});
  }

  Stand() {
    setState(() {});
  }

    Widget dealerCard(var cardnumber1, var cardnumber2) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          bottom: 2,
          top: 2,
          child: Transform.rotate(
            angle: -0.2,
            child: Image.asset(
              'assets/$card.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),
        Positioned(
          left: 50,
          bottom: 2,
          top: 2,
          child: Transform.rotate(
            angle: 0.2,
            child: Image.asset(
              'assets/$card2.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),
      ],
      overflow: Overflow.clip,
    );
  }

  Widget playerCard(var cardnumber1, var cardnumber2) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          bottom: 2,
          top: 2,
          child: Transform.rotate(
            angle: -0.2,
            child: Image.asset(
              'assets/$card.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),
        Positioned(
          left: 50,
          bottom: 2,
          top: 2,
          child: Transform.rotate(
            angle: 0.2,
            child: Image.asset(
              'assets/$card2.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2,
          top: MediaQuery.of(context).size.height / 4,
          child: Column(
            children: <Widget>[
              FlatButton(
                color: Colors.green,
                child: Text("HIT"),
                onPressed: () => Hit(),
              ),
              FlatButton(
                color: Colors.red,
                child: Text("STAND"),
                onPressed: () => Stand(),
              ),
            ],
          ),
        )
      ],
      overflow: Overflow.clip,
    );
  }
}
