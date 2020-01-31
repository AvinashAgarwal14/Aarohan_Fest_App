import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:aavishkarapp/ui/games/21-card-game/model.dart';
import 'package:http/http.dart' as http;

class BlackJack extends StatefulWidget {
  var coins_left;
  var fix;
  var currentUser;
  var betAmount;
  String help;
  BlackJack(
      this.coins_left, this.fix, this.currentUser, this.betAmount, this.help);
  @override
  _BlackJackState createState() =>
      _BlackJackState(coins_left, fix, currentUser, betAmount, help);
}

class _BlackJackState extends State<BlackJack> {
  var coins_left;
  var fix;
  var currentUser;
  var betAmount;
  String help;
  bool _eurekoinLoading = false;
  bool _isLoading = false;
  final loginKey = 'itsnotvalidanyways';

  final databaseReference =
      FirebaseDatabase.instance.reference().child("Games");

  PersistentBottomSheetController _controller;
  _BlackJackState(
      this.coins_left, this.fix, this.currentUser, this.betAmount, this.help);

  BlackJackModel blackJack;
  Future getUserEurekoin() async {
    setState(() {
      _eurekoinLoading = true;
    });
    var email = currentUser.email;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://ekoin.nitdgplug.org/api/coins/?token=$encoded";
    http.Response response = await http.get(apiUrl);
    print(response);
    var status = json.decode(response.body)['coins'];
    print(status);
    setState(() {
      coins_left = status;
      _eurekoinLoading = false;
    });
    _controller.setState(() {
      _eurekoinLoading = false;
    });
  }

  Future<int> transferEurekoin(
      var amount, String transerTo, String transferFrom) async {
    setState(() {
      _isLoading = true;
    });
    var email = transferFrom;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);
    String apiUrl =
        "https://ekoin.nitdgplug.org/api/transfer/?token=$encoded&amount=$amount&email=$transerTo";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var status = json.decode(response.body)['status'];
    setState(() {
      _isLoading = false;
    });
    getUserEurekoin();
    return int.parse(status);
  }

  void showDialog(BuildContext context, int code) async {
    Color status = Colors.green.withOpacity(0.8);
    if (code == 1) status = Colors.red.withOpacity(0.8);
    if (code == 2) status = Colors.yellow.withOpacity(0.8);
    var result;
    if (code == 0)
      result = "winner";
    else if (code == 1)
      result = "loser";
    else
      result = "draw";

    setState(() {
      _isLoading = true;
      _eurekoinLoading = true;
    });
    _controller = Scaffold.of(context).showBottomSheet((context) {
      return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          Navigator.pop(context);

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
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
                result,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                result == "winner"
                    ? "YOU WIN $betAmount coins"
                    : result == "loser"
                        ? "YOU LOSE $betAmount coins"
                        : "IT'S A DRAW",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              _eurekoinLoading
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: status,
                      ),
                    )
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      color: Colors.white,
                      onPressed: () {
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                                statusBarColor: Colors.transparent,
                                systemNavigationBarIconBrightness:
                                    Brightness.dark));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "TRY AGAIN",
                        style: TextStyle(
                            color:
                                result == "winner" ? Colors.green : Colors.red),
                      ),
                    ),
            ],
          ),
        ),
      );
    });

    // Response response =
    //     await Dio().post("https://aavishkargames.herokuapp.com/create/", data: {
    //   "email": currentUser.email,
    //   "status": result,
    //   "type": "blackjack",
    //   "amount": betAmount
    // });

    result == "winner"
        ? transferEurekoin(
            betAmount, currentUser.email, "blackjack@eurekoin.com")
        : transferEurekoin(
            betAmount, "blackjack@eurekoin.com", currentUser.email);

    var gameStatus = {
      "name": currentUser.displayName,
      "status": result,
      "type": "blackjack",
      "amount": betAmount
    };

    var recentLen;
    var recentData;
    await databaseReference
        .child("Recent")
        .once()
        .then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      recentData = snapshot.value;
      recentLen = snapshot.value.length;
    });
    if (recentLen >= 10) {
      int i = recentLen - 10;
      String remove;
      recentData.forEach((dynamic str, dynamic player) async {
        if (i == 0)
          return;
        else {
          remove = str;
          i--;
        }
        print(remove);
        databaseReference.child("Recent").child(remove).remove();
      });
    }

    int current;
    int max;

    await databaseReference.child("Recent").push().set(gameStatus);

    await databaseReference
        .child("Blackjack")
        .once()
        .then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      current = snapshot.value["Current"];
      max = snapshot.value["Max"];
    });
    int change;
    print(" $current gfgf $betAmount");
    if (result == "winner")
      change = current + betAmount;
    else if (result == "draw") {
      change = current;
    } else
      change = current - betAmount;

    databaseReference.child("Blackjack").set({"Current": change, "Max": max});

    print(gameStatus);

    // http.Response response = await http.post(
    //     "https://aarohan-76222.firebaseio.com/Games/Recent.json",
    //     body: json.encode(gameStatus));
    // print("here ${response.body}");

    setState(() {
      getUserEurekoin();
      _isLoading = false;
    });
  }

  void setHelp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("help2", "true");
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    blackJack = new BlackJackModel(fix);
    setState(() {
      blackJack.start();
      if (blackJack.winner != -1) {
        showDialog(context, blackJack.winner);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
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
                            child: help == "false"
                                ? Scrollbar(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          margin: EdgeInsets.all(5),
                                          child: Text(
                                            "\nINSTRUCTIONS:\n\n\n🂡 The goal of blackjack is to beat the dealer's hand without going over 21\n\n🂡 Face cards are worth 10. Aces are worth 1 or 11, whichever makes a better hand\n\n🂡 To 'Hit' is to ask for another card. To 'Stand' is to hold your total and end your turn, if you go over 21 you bust, and the dealer wins regardless of the dealer's hand",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Color(0xFFD3A372),
                                          child: Text(
                                            "PROCEED",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                  )
                                : Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: _coinsLeft(coins_left),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            color: Colors.white.withOpacity(0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.all(4.0),
                                            padding: EdgeInsets.all(10.0),
                                            child: cardDisplay(
                                                blackJack.dealerCards, 1),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "DEALER",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 16,
                                          child: Container(
                                            color: Colors.white.withOpacity(0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.all(4.0),
                                            padding: EdgeInsets.all(10.0),
                                            child: cardDisplay(
                                                blackJack.playerCards, 0),
                                          ),
                                        ),
                                        blackJack.currentMove == 1
                                            ? Container()
                                            : Expanded(
                                                flex: 6,
                                                child: Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ButtonTheme(
                                                        minWidth: 100,
                                                        height: 40,
                                                        child: RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .horizontal(
                                                                      left: Radius
                                                                          .circular(
                                                                              20))),
                                                          color: Colors.green,
                                                          child: Text(
                                                            "HIT",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          onPressed: () =>
                                                              {Hit(ctx)},
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ButtonTheme(
                                                        minWidth: 100,
                                                        height: 40,
                                                        child: RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .horizontal(
                                                                      left: Radius
                                                                          .circular(
                                                                              20))),
                                                          color: Colors.red,
                                                          child: Text(
                                                            "STAND",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          onPressed: () =>
                                                              Stand(ctx),
                                                        ),
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
                                      statusBarColor: Colors.transparent,
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

  Widget _coinsLeft(var coins_left) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 5.0,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                child: _eurekoinLoading
                    ? Container(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ))
                    : Text(
                        '$coins_left',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.white),
                      ),
              ),
            ),
            Image.asset('assets/coined.png'),
          ],
        ),
      ),
    );
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
      const oneSec = const Duration(milliseconds: 1500);
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
              child: Text("  ${blackJack.playerScores[1]}",
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
              child: Text("  ${blackJack.dealerScores[1]}",
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
