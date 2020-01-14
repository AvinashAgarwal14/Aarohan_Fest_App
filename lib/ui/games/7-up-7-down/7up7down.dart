import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = new List();
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class UpDownGame extends StatefulWidget {
  var coins_left;
  var fix;
  var currentUser;
  var betAmount;
  UpDownGame(this.coins_left, this.fix, this.currentUser, this.betAmount);
  @override
  _UpDownGameState createState() =>
      _UpDownGameState(coins_left, fix, currentUser, betAmount);
}

class _UpDownGameState extends State<UpDownGame> {
  var coins_left;
  var fix;
  var currentUser;
  var betAmount;
  _UpDownGameState(this.coins_left, this.fix, this.currentUser, this.betAmount);
  var value;
  var result;
  var upordown;
  bool picked = false;
  var dice1 = 1;
  var dice2 = 2;
  bool _isLoading = false;
  bool _eurekoinLoading = false;
  bool help = false;
  bool rolling = false;
  final loginKey = 'itsnotvalidanyways';
  List<dynamic> recentResult;

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
  }

  void submit(context, result) async {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("THE TOTAL SUM IS $value. YOUR BET WAS 7$upordown"),
              Text(result == "winner"
                  ? "YOU WIN $betAmount COINS"
                  : "YOU LOSE $betAmount COINS"),
              RaisedButton(
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      systemNavigationBarIconBrightness: Brightness.dark));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("GO BACK"),
              ),
            ],
          ),
        ),
      );
    });

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response =
        await Dio().post("https://aavishkargames.herokuapp.com/create/", data: {
      "email": currentUser.email,
      "status": result,
      "type": "sevenup",
      "amount": betAmount
    });
    setState(() {
      getUserEurekoin();
      _isLoading = false;
    });
    print(response.data);
    await prefs.setInt('coins', coins_left);
  }

  void getRecent() async {
    setState(() {
      _isLoading = true;
    });
    Response response =
        await Dio().get("https://aavishkargames.herokuapp.com/list/sevenup/");
    recentResult = response.data["result"];
    print(recentResult);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecent();
    print(fix);
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
          builder: (context) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/dicebg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
              child: SafeArea(
                child: Stack(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.all(4.0),
                    child: !help
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(5),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "\nINSTRUCTIONS:\n\n\n🎲 choose 7↑ or 7↓\n\n🎲 if the sum of the dice faces is according to you bet, you win back twice the amount\n\n🎲 otherwise you lose your bet",
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              _isLoading
                                  ? Container(
                                      child: CircularProgressIndicator(),
                                    )
                                  : FlatButton(
                                      color: Colors.white,
                                      child: Text("PROCEED"),
                                      onPressed: () {
                                        setState(() {
                                          help = true;
                                        });
                                      },
                                    )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _coinsLeft(coins_left),
                              _diceDisplay(),
                              rolling && picked ? Container() : _start(context),
                              SizedBox(
                                height: 20,
                              ),
                              picked
                                  ? Container()
                                  : Expanded(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              child: _upButton(),
                                            ),
                                            Expanded(
                                              child: _downButton(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: CarouselSlider(
                                  items: map<Widget>(
                                    recentResult,
                                    (index, i) {
                                      return ListTile(
                                        leading:
                                            Text(recentResult[index]["email"].split("@")[0]),
                                        title: Text(
                                          "${recentResult[index]["status"]}: ${recentResult[index]["amount"]} coins",
                                          style: TextStyle(
                                              color: recentResult[index]
                                                          ["status"] ==
                                                      "winner"
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                  viewportFraction: 1.0,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 700),
                                  autoPlayCurve: Curves.easeIn,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(milliseconds: 100),
                                ),
                              )
                            ],
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
                      color: Color(0xFF008F23),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _coinsLeft(var coins_left) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(left: 230),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Expanded(
            child: Image.asset('assets/coined.png'),
          ),
        ],
      ),
    );
  }

  Widget _start(context) {
    return FlatButton(
      color: Color(0xFF008F23),
      onPressed: () {
        setState(() {
          rolling = true;
        });
        if (!picked) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("please pick 7 UP or 7 DOWN"),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF008F23),
            elevation: 3.0,
          ));
        } else {
          if (fix == 0) {
            const oneSec = const Duration(milliseconds: 100);
            var loop = 30;
            Timer.periodic(
                oneSec,
                (Timer t) => setState(() {
                      loop--;
                      dice1 = 1 + Random().nextInt(5);
                      dice2 = 1 + Random().nextInt(5);
                      if (loop == 0) {
                        value = dice1 + dice2;
                        print(value);
                        if ((upordown == "up" && value > 7) ||
                            (upordown == "down" && value < 7)) {
                          result = "winner";
                        } else {
                          result = "loser";
                        }
                        submit(context, result);
                        t.cancel();
                      }
                    }));
          } else if (fix == 1) {
            const oneSec = const Duration(milliseconds: 100);
            var loop = 30;
            Timer.periodic(
              oneSec,
              (Timer t) => setState(
                () {
                  loop--;
                  dice1 = 1 + Random().nextInt(5);
                  dice2 = 1 + Random().nextInt(5);
                  if (loop == 0) {
                    if (upordown == "up") {
                      dice1 = 4 + Random().nextInt(2);
                      dice2 = 4 + Random().nextInt(2);
                    } else {
                      dice1 = 1 + Random().nextInt(2);
                      dice2 = 1 + Random().nextInt(2);
                    }
                    value = dice1 + dice2;
                    print(upordown);
                    print("winner$value");
                    result = "winner";
                    t.cancel();
                    submit(context, result);
                  }
                },
              ),
            );
          } else if (fix == -1) {
            const oneSec = const Duration(milliseconds: 100);
            var loop = 30;
            Timer.periodic(
              oneSec,
              (Timer t) => setState(
                () {
                  loop--;
                  dice1 = 1 + Random().nextInt(5);
                  dice2 = 1 + Random().nextInt(5);
                  if (loop == 0) {
                    if (upordown == "up") {
                      dice1 = 1 + Random().nextInt(2);
                      dice2 = 1 + Random().nextInt(2);
                    } else {
                      dice1 = 4 + Random().nextInt(2);
                      dice2 = 4 + Random().nextInt(2);
                    }
                    value = dice1 + dice2;
                    print(upordown);
                    print("loser$value");
                    result = "loser";
                    t.cancel();
                    submit(context, result);
                  }
                },
              ),
            );
          }
        }
      },
      child: Text(
        'ROLL',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white),
      ),
    );
  }

  Widget _downButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
          upordown = "up";
          picked = true;
          rolling = false;
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.arrow_upward,
            size: 41,
            color: Colors.white,
          ),
          Text(
            "7",
            style: TextStyle(
              fontSize: 41,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _upButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
          upordown = "down";
          picked = true;
          rolling = false;
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.arrow_downward,
            size: 41,
            color: Colors.white,
          ),
          Text(
            "7",
            style: TextStyle(
              fontSize: 41,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _diceDisplay() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Image.asset('assets/$dice1.png'),
            ),
            Expanded(
              child: Image.asset('assets/$dice2.png'),
            ),
          ],
        ),
      ),
    );
  }
}
