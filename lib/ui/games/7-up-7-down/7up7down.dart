import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpDownGame extends StatefulWidget {
  var coins_left;
  var fix;
  var currentUser;
  int betAmount;

  String help = "false";
  UpDownGame(
      this.coins_left, this.fix, this.currentUser, this.betAmount, this.help);
  @override
  _UpDownGameState createState() =>
      _UpDownGameState(coins_left, fix, currentUser, betAmount, help);
}

class _UpDownGameState extends State<UpDownGame> {
  var coins_left;
  var fix;
  var currentUser;
  int betAmount;
  String help = "false";
  _UpDownGameState(
      this.coins_left, this.fix, this.currentUser, this.betAmount, this.help);
  var value;
  var result;
  var upordown;
  bool picked = false;
  var dice1 = 1;
  var dice2 = 2;
  bool _isLoading = false;
  bool _eurekoinLoading = false;
  bool rolling = false;
  final loginKey = 'itsnotvalidanyways';
  PersistentBottomSheetController _controller;

  final databaseReference =
      FirebaseDatabase.instance.reference().child("Games");

  Future getUserEurekoin() async {
    setState(() {
      _eurekoinLoading = true;
    });
    var email = currentUser.providerData[1].email;
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

  void submit(context, result) async {
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
              statusBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(spreadRadius: 10, blurRadius: 10)],
            color: result == "winner" ? Colors.green : Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "THE TOTAL SUM IS $value. YOUR BET WAS 7$upordown",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                result == "winner"
                    ? "YOU WIN $betAmount COINS"
                    : "YOU LOSE $betAmount COINS",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              _eurekoinLoading
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    )
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      color: Colors.white,
                      onPressed: () {
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                                statusBarColor: Colors.white,
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
    result == "winner"
        ? transferEurekoin(
            betAmount, currentUser.providerData[1].email, "singhsimrananshu@gmail.com")
        : transferEurekoin(
            betAmount, "singhsimrananshu@gmail.com", currentUser.providerData[1].email);

    var gameStatus = {
      "name": currentUser.providerData[1].displayName,
      "status": result,
      "type": "sevenup",
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
        .child("7up7down")
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
    else
      change = current - betAmount;

    databaseReference.child("7up7down").set({"Current": change, "Max": max});

    // http.Response responseTest = await http
    //     .get("https://aarohan-76222.firebaseio.com/Games/Recent.json");
    // var eachRecentResult = json.decode(responseTest.body);
    // print(eachRecentResult);
    // print("size: ${eachRecentResult.length}");

    // if (eachRecentResult.length >= 10) {
    //   int i = eachRecentResult.length - 10;
    //   String remove;
    //   eachRecentResult.forEach((String str, dynamic player) async {
    //     if (i == 0)
    //       return;
    //     else {
    //       remove = str;
    //       i--;
    //     }

    //     await http.delete(
    //         "https://aarohan-76222.firebaseio.com/Games/Recent/$remove.json");
    //   });
    // }

    //   http.Response response = await http.post(
    //       "https://aarohan-76222.firebaseio.com/Games/Recent.json",
    //       body: json.encode(gameStatus));
    //   print("here ${response.body}");

    //   http.Response res = await http
    //       .get("https://aarohan-76222.firebaseio.com/Games/7up7down.json");
    //   print(json.decode(res.body));

    setState(() {
      _isLoading = false;
    });
  }

  void setHelp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("help1", "true");
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
                    child: help == "false"
                        ? Scrollbar(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    "\nINSTRUCTIONS:\n\n\n🎲 choose 7↑ or 7↓\n\n🎲 if the sum of the dice faces is according to your bet, you win back twice the amount\n\n🎲 otherwise you lose your bet",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FlatButton(
                                  color: Color(0xFF0187F8),
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
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 50,
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

  Widget _start(context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      color: Color(0xFFfc8200),
      onPressed: () {
        setState(() {
          rolling = true;
        });
        if (!picked) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("please pick 7 UP or 7 DOWN"),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFFfc8200),
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
