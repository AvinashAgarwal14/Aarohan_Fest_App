import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:aavishkarapp/ui/games/7-up-7-down/7up7down.dart';
import 'package:aavishkarapp/ui/games/21-card-game/blackjack.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  var userEurekoin = 0;
  final loginKey = 'itsnotvalidanyways';
  var betAmount;

  Future _getUser() async {
    setState(() {
      _eurekoinLoading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
      _eurekoinLoading = false;
    });
  }

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
      userEurekoin = status;
      _eurekoinLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser().then((val) {
      getUserEurekoin();
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  var coins_left;
  var fix = 2;
  bool _isLoading = false;
  bool _eurekoinLoading = false;
  GlobalKey _scaffoldkey = GlobalKey();

  void getTossDice(betAmount) async {
    setState(() {
      _isLoading = true;
    });
    Response response2 = await Dio().post(
        "https://aavishkargames.herokuapp.com/toss/",
        data: {"email": currentUser.email});

    fix = response2.data["status"];
    print(fix);

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UpDownGame(userEurekoin, fix, currentUser, betAmount)))
        .then((value) {
      setState(() {
        getUserEurekoin();
      });
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFF008F23),
        systemNavigationBarIconBrightness: Brightness.dark));
    setState(() {
      _isLoading = false;
    });
  }

  void getTossCard() async {
    setState(() {
      _isLoading = true;
    });
    Response response2 = await Dio().post(
        "https://aavishkargames.herokuapp.com/toss/",
        data: {"email": currentUser.email});

    fix = response2.data["result"];
    print(fix);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BlackJack(userEurekoin, fix))).then((value) {
      setState(() {
        getUserEurekoin();
      });
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF2837A),
        systemNavigationBarIconBrightness: Brightness.dark));
    setState(() {
      _isLoading = false;
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
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.dark));
            },
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "CASINO",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.attach_money,
                    color: Colors.green[900],
                    //Color(0xFF4ef037),
                    size: 34,
                  ),
                  _eurekoinLoading
                      ? Container(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green[900],
                          ),
                        )
                      : Text(
                          "$userEurekoin",
                          style: TextStyle(color: Colors.green[900]),
                        ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) => _isLoading
              ? Container(
                  child: LinearProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).showBottomSheet((context) {
                            return Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 5, blurRadius: 5)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                height: MediaQuery.of(context).size.height / 6,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "CHOOSE YOUR BET",
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        FlatButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "10",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                              betAmount = 10;
                                              if (betAmount > userEurekoin) {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    "NOT ENOUGH EUREKOINS",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor: Colors.white,
                                                  elevation: 3.0,
                                                ));
                                              } else {
                                                getTossDice(10);
                                              }
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "15",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            betAmount = 15;
                                            if (betAmount > userEurekoin) {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "NOT ENOUGH EUREKOINS",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                duration: Duration(seconds: 1),
                                                backgroundColor: Colors.white,
                                                elevation: 3.0,
                                              ));
                                            } else {
                                              getTossDice(15);
                                            }
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "20",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            betAmount = 20;
                                            if (betAmount > userEurekoin) {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "NOT ENOUGH EUREKOINS",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                duration: Duration(seconds: 1),
                                                backgroundColor: Colors.white,
                                                elevation: 3.0,
                                              ));
                                            } else {
                                              getTossDice(20);
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          }, backgroundColor: Colors.white.withOpacity(0));
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/dicegame.jpg"),
                                fit: BoxFit.cover),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                            child: SafeArea(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "7 UP 7 DOWN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        BoxShadow(
                                            spreadRadius: 7, blurRadius: 7)
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).showBottomSheet((context) {
                            return Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 7, blurRadius: 9)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                height: MediaQuery.of(context).size.height / 6,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "ENTER THE GAME?",
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        FlatButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);

                                              getTossCard();
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "No",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          }, backgroundColor: Colors.white.withOpacity(0));
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/cardgame.jpg"),
                                fit: BoxFit.cover),
                          ),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: SafeArea(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.topLeft,
                                  child: Text("BLACKJACK",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            BoxShadow(
                                                spreadRadius: 7, blurRadius: 7)
                                          ])),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
