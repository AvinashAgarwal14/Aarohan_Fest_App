import 'dart:ui';
import 'package:aavishkarapp/ui/dashboard/dashboard_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../eurekoin/eurekoin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/drawer.dart';

import 'dart:async';
import 'package:aavishkarapp/ui/games/7-up-7-down/7up7down.dart';
import 'package:aavishkarapp/ui/games/21-card-game/blackjack.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  var userEurekoin = 0;
  final loginKey = 'itsnotvalidanyways';
  var betAmount;
  int isEurekoinAlreadyRegistered = null;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser().then((val) {
      isEurekoinUserRegistered();
    });
    getRecent();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  Future _getUser() async {
    setState(() {
      _eurekoinLoading = true;
      _enterLoading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
      // _eurekoinLoading = false;
    });
  }

  Future isEurekoinUserRegistered() async {
    var email = currentUser.email;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);
    String apiUrl = "https://ekoin.nitdgplug.org/api/exists/?token=$encoded";
    http.Response response = await http.get(apiUrl);
    var status = json.decode(response.body)['status'];
    if (status == '1') {
      setState(() {
        isEurekoinAlreadyRegistered = 1;
      });
      getUserEurekoin();
    } else
      setState(() {
        isEurekoinAlreadyRegistered = 0;
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
    _controller.setState(() {
      _eurekoinLoading = false;
    });
  }

  String help1 = "false";
  String help2 = "false";

  var fix = 2;
  bool _isLoading = false;
  bool _eurekoinLoading = false;
  bool _enterLoading = false;
  GlobalKey _scaffoldkey = GlobalKey();
  List<dynamic> recentResult;

  PersistentBottomSheetController _controller;

  void getXvalue(game, betAmount) async {
    setState(() {
      _isLoading = true;
    });

    http.Response response =
        await http.get("https://aarohan-76222.firebaseio.com/Games/$game.json");
    var xValue = json.decode(response.body)["Max"];
    var currentValue = json.decode(response.body)["Current"];
    print(xValue);
    print(currentValue);
    if (currentValue > xValue / 2)
      fix = 1;
    else if (currentValue < -(xValue / 2))
      fix = -1;
    else
      fix = 0;

    print("fix: $fix");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    game == "7up7down"
        ? help1 = prefs.getString("help1") ?? "false"
        : help2 = prefs.getString("help2") ?? "false";
    game == "7up7down"
        ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpDownGame(
                        userEurekoin, fix, currentUser, betAmount, help1)))
            .then((value) {
            setState(() {
              getUserEurekoin();
              getRecent();
            });
          })
        : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlackJack(
                        userEurekoin, fix, currentUser, betAmount, help2)))
            .then((value) {
            setState(() {
              getUserEurekoin();
              getRecent();
            });
          });
    game == "7up7down"
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Color(0xFF0187F8),
            systemNavigationBarIconBrightness: Brightness.dark))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Color(0xFFD3A372),
            systemNavigationBarIconBrightness: Brightness.dark));

    setState(() {
      _isLoading = false;
    });
  }

  void getRecent() async {
    setState(() {
      _enterLoading = true;
    });
    http.Response response = await http
        .get("https://aarohan-76222.firebaseio.com/Games/Recent.json");
    var eachRecentResult = json.decode(response.body);

    recentResult = List<dynamic>();
    if (eachRecentResult != null) {
      eachRecentResult.forEach((String ignore, dynamic player) {
        recentResult.add(player);
      });
    } else
      recentResult = null;

    setState(() {
      _enterLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light));
      },
      child: (isEurekoinAlreadyRegistered == null || _enterLoading)
          ? Scaffold(
              backgroundColor: Color(0xFFFFA594),
              body: Center(
                child: Image.asset("assets/loading.gif"),
              ),
            )
          : (isEurekoinAlreadyRegistered == 1)
              ? Scaffold(
                  key: _scaffoldkey,
                  appBar: AppBar(
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    leading: BackButton(
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                                  statusBarColor: Colors.white,
                                  systemNavigationBarIconBrightness:
                                      Brightness.dark));
                        });
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
                  drawer: NavigationDrawer(),
                  backgroundColor: Colors.white,
                  body: Builder(
                    builder: (context) => _isLoading
                        ? Container(
                            color: Color(0xFFFFA594),
                            child: Center(
                              child: Image.asset("assets/loading.gif"),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                flex: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    _controller = Scaffold.of(context)
                                        .showBottomSheet((context) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 5,
                                                    blurRadius: 5)
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          child: _eurekoinLoading
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    "FETCHING EUREKOINS. TRY AGAIN",
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      child: Text(
                                                        "CHOOSE YOUR BET",
                                                        style:
                                                            GoogleFonts.signika(
                                                                fontSize: 21,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "10",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                              betAmount = 10;
                                                              if (betAmount >
                                                                  userEurekoin) {
                                                                Scaffold.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    "NOT ENOUGH EUREKOINS",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation:
                                                                      3.0,
                                                                ));
                                                              } else {
                                                                getXvalue(
                                                                    "7up7down",
                                                                    10);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "15",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            betAmount = 15;
                                                            if (betAmount >
                                                                userEurekoin) {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "NOT ENOUGH EUREKOINS",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 3.0,
                                                              ));
                                                            } else {
                                                              getXvalue(
                                                                  "7up7down",
                                                                  15);
                                                            }
                                                          },
                                                        ),
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "20",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            betAmount = 20;
                                                            if (betAmount >
                                                                userEurekoin) {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "NOT ENOUGH EUREKOINS",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 3.0,
                                                              ));
                                                            } else {
                                                              getXvalue(
                                                                  "7up7down",
                                                                  20);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ));
                                    },
                                            backgroundColor:
                                                Colors.white.withOpacity(0));
                                  },
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height / 2.5,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/dicegame.jpg"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5.0, sigmaY: 5.0),
                                      child: SafeArea(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "7 UP 7 DOWN",
                                            style: GoogleFonts.acme(
                                                color: Colors.white,
                                                fontSize: 42,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  BoxShadow(
                                                      spreadRadius: 7,
                                                      blurRadius: 7)
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    _controller = Scaffold.of(context)
                                        .showBottomSheet((context) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 5,
                                                    blurRadius: 5)
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          child: _eurekoinLoading
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    "FETCHING EUREKOINS. TRY AGAIN",
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      child: Text(
                                                        "CHOOSE YOUR BET",
                                                        style:
                                                            GoogleFonts.signika(
                                                                fontSize: 21,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "10",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                              betAmount = 10;
                                                              if (betAmount >
                                                                  userEurekoin) {
                                                                Scaffold.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    "NOT ENOUGH EUREKOINS",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation:
                                                                      3.0,
                                                                ));
                                                              } else {
                                                                getXvalue(
                                                                    "Blackjack",
                                                                    10);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "15",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            betAmount = 15;
                                                            if (betAmount >
                                                                userEurekoin) {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "NOT ENOUGH EUREKOINS",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 3.0,
                                                              ));
                                                            } else {
                                                              getXvalue(
                                                                  "Blackjack",
                                                                  15);
                                                            }
                                                          },
                                                        ),
                                                        FloatingActionButton(
                                                          child: Text(
                                                            "20",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            betAmount = 20;
                                                            if (betAmount >
                                                                userEurekoin) {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "NOT ENOUGH EUREKOINS",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 3.0,
                                                              ));
                                                            } else {
                                                              getXvalue(
                                                                  "Blackjack",
                                                                  20);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ));
                                    },
                                            backgroundColor:
                                                Colors.white.withOpacity(0));
                                  },
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height / 2.5,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/cardgame.jpg"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3.0, sigmaY: 3.0),
                                        child: SafeArea(
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            alignment: Alignment.topLeft,
                                            child: Text("BLACKJACK",
                                                style: GoogleFonts.acme(
                                                    letterSpacing: 2,
                                                    color: Colors.white,
                                                    fontSize: 42,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      BoxShadow(
                                                          spreadRadius: 7,
                                                          blurRadius: 7)
                                                    ])),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: recentResult == null ||
                                          recentResult.length <= 0
                                      ? Container()
                                      : CarouselSlider(
                                          items: map<Widget>(
                                            recentResult,
                                            (index, i) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  VerticalDivider(
                                                    color: Colors.black,
                                                    thickness: 3,
                                                  ),
                                                  recentResult[index]
                                                              ["email"] !=
                                                          null
                                                      ? Text(
                                                          recentResult[index]
                                                                  ["email"]
                                                              .split("@")[0],
                                                          style: GoogleFonts
                                                              .signika(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      : Text(""),
                                                  Text(
                                                    "${recentResult[index]["status"]}: ${recentResult[index]["amount"]} coins",
                                                    style: GoogleFonts.signika(
                                                        color: recentResult[
                                                                        index][
                                                                    "status"] ==
                                                                "winner"
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          viewportFraction: 1.0,
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 700),
                                          autoPlayCurve: Curves.easeIn,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(milliseconds: 100),
                                        ),
                                ),
                              )
                            ],
                          ),
                  ),
                )
              : EurekoinHomePage(),
    );
  }
}
