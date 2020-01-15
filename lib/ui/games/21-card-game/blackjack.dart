import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:aavishkarapp/ui/games/21-card-game/model.dart';

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

  BlackJackModel blackJack;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blackJack = new BlackJackModel();
    setState(() {
      blackJack.start();
    });
  }

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
        body: Builder(
            builder: (BuildContext ctx) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fcards.jpg'),
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
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20.0)),
                            // margin: EdgeInsets.all(10.0),
                            // padding: EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      color: Colors.white.withOpacity(0),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(4.0),
                                      padding: EdgeInsets.all(10.0),
                                      child:
                                          cardDisplay(blackJack.dealerCards, 1),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      color: Colors.white.withOpacity(0),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(4.0),
                                      padding: EdgeInsets.all(10.0),
                                      child:
                                          cardDisplay(blackJack.playerCards, 0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FlatButton(
                                            color: Colors.green,
                                            child: Text("HIT"),
                                            onPressed: () => {Hit(ctx)},
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FlatButton(
                                            color: Colors.red,
                                            child: Text("STAND"),
                                            onPressed: () => Stand(ctx),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                            onPressed: () {
                              Navigator.pop(context);
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                      statusBarColor: Colors.white,
                                      systemNavigationBarIconBrightness:
                                          Brightness.dark));
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
                )),
      ),
    );
  }

  Widget showDialog(BuildContext context, int code) {
    Color status = Colors.green.withOpacity(0.8);
    if (code == 1) status = Colors.red.withOpacity(0.8);
    if (code == 2) status = Colors.yellow.withOpacity(0.8);

    Scaffold.of(context).showBottomSheet((context) {
      return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          Navigator.pop(context);

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(spreadRadius: 10, blurRadius: 10)],
            color: status,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "WIN",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "YOU LOSE 0 COINS",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              RaisedButton(
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      systemNavigationBarIconBrightness: Brightness.dark));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("TRY AGAIN"),
              ),
            ],
          ),
        ),
      );
    });
  }

  Hit(BuildContext context) {
    setState(() {
      blackJack.hit();
      if (blackJack.winner != -1) {
        showDialog(context, blackJack.winner);
      }
    });
  }

  Stand(BuildContext context) {
    setState(() {
      blackJack.stand();
      const oneSec = const Duration(seconds: 1);
      Timer.periodic(oneSec, (Timer t) {
        Hit(context);
        if (blackJack.winner != -1) {
        t.cancel();
      }
      });
    });
  }

  Widget cardDisplay(List cards, int side) {
    var pos = 0.0;
    var cardsWidget = <Positioned>[];

    cards.forEach((card) {
      cardsWidget.add(Positioned(
        left: pos,
        bottom: 2,
        top: 2,
        child: Image.asset(
          'assets/$card.png',
          width: MediaQuery.of(context).size.width / 3,
        ),
      ));
      pos += 35;
    });
    cardsWidget.add(Positioned(
      left: pos + (MediaQuery.of(context).size.width / 3) - 15,
      top: 50,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/score.png"))),
        child: Center(
            child: Text(
                side == 0
                    ? "  ${blackJack.playerScores[0]}"
                    : "  ${blackJack.dealerScores[0]}",
                style: TextStyle(color: Colors.black))),
      ),
    ));

    if (side == 0 && blackJack.playerScores.length > 1) {
      cardsWidget.add(Positioned(
        left: pos + (MediaQuery.of(context).size.width / 3) - 15,
        top: 90,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/score.png"))),
          child: Center(
              child: Text(
                      "  ${blackJack.playerScores[1]}",
                  style: TextStyle(color: Colors.black))),
        ),
      ));
    }

    if (side == 1 && blackJack.dealerScores.length > 1) {
      cardsWidget.add(Positioned(
        left: pos + (MediaQuery.of(context).size.width / 3) - 15,
        top: 90,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/score.png"))),
          child: Center(
              child: Text(
                      "  ${blackJack.dealerScores[1]}",
                  style: TextStyle(color: Colors.black))),
        ),
      ));
    }

    return Stack(
      children: cardsWidget,
      overflow: Overflow.clip,
    );
  }
}
