import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:aavishkarapp/games/7-up-7-down/7up7down.dart';
import 'package:aavishkarapp/games/21-card-game/blackjack.dart';
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

  Future _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
  }

  Future getUserEurekoin() async {
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
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser().then((val) {
      getUserEurekoin();
    });
  }

  var coins_left;
  var fix = 2;
  bool _isLoading = false;
  GlobalKey _scaffoldkey = GlobalKey();

  void getTossDice() async {
    setState(() {
      _isLoading = true;
    });
    Response response2 = await Dio().post(
        "https://aavishkargames.herokuapp.com/sevenup/toss",
        data: {"email": "romitkarmakar@gmail.com"});

    fix = response2.data["result"];
    print(fix);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpDownGame(userEurekoin, fix))).then((value) {
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
        "https://aavishkargames.herokuapp.com/sevenup/toss",
        data: {"email": "romitkarmakar@gmail.com"});

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
            color: Colors.orange[400],
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
                    color: Colors.orange[400],
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
                  Text(
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
                  children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Scaffold.of(context).showBottomSheet((context) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          "use 10 eurekoins to enter game?",
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.blue[900]),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            FlatButton(
                                              color: Colors.blue[900],
                                              child: Text("Yes"),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);

                                                  getTossDice();
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              color: Colors.blue[900],
                                              child: Text("No"),
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
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/dicegame.jpg"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          Text("7 UP 7 DOWN"),
                          GestureDetector(
                            onTap: () {
                              
                              Scaffold.of(context).showBottomSheet((context) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          "use 10 eurekoins to enter game?",
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.blue[900]),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            FlatButton(
                                              color: Colors.blue[900],
                                              child: Text("Yes"),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);

                                                  getTossCard();
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              color: Colors.blue[900],
                                              child: Text("No"),
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
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/cardgame.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Text("BLACKJACK")
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
