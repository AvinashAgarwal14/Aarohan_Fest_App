import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:arhn_app_2021/ui/dashboard/dashboard.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:arhn_app_2021/ui/account/login.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  FirebaseUser currentUser;
  int isEurekoinAlreadyRegistered;
  String barcodeString;
  final loginKey = 'itsnotvalidanyways';
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  int click = 0, gclick = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final _facebookLogin = new FacebookLogin();
  Map userProfile;

  bool previouslyLoggedIn = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    currentUser = await _auth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Opacity(
        opacity: 1,
        child: Drawer(
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            child: ListTileTheme(
              iconColor: Color.fromRGBO(255, 255, 255, 1.0),
              textColor: Color.fromRGBO(255, 255, 255, 1.0),
              selectedColor: Theme.of(context).primaryColor.withOpacity(1.0),
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                // DrawerHeader(
                //   padding: EdgeInsets.all(0.0),
                //   child: Image.asset("images/gifs/pacman.gif", fit: BoxFit.cover),
                // ),
                Container(
                  // color: Colors.blue[200].withOpacity(1),
                  child: ListTile(
                    title: Text(
                      '${currentUser.providerData[1].displayName}',
                      style: GoogleFonts.ubuntu(
                        fontSize: 17,
                        color: Color(0xFF6B872B),
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        currentUser.providerData[1].photoUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    subtitle: Text(
                      "${currentUser.providerData[1].email}",
                      style: GoogleFonts.ubuntu(fontSize: 13),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text(
                    "Dashboard",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/ui/dashboard");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                  ),
                  title: Text(
                    "Eurekoin Wallet",
                  ),
                  onTap: () {
                    Navigator.popUntil(
                        context, (ModalRoute.withName('/ui/account/login')));
                    Navigator.of(context).pushNamed("/ui/eurekoin");
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.casino,
                //   ),
                //   title: Text(
                //     "Eurekoin Casino",
                //   ),
                //   onTap: (() {
                //     Navigator.popUntil(
                //         context, (ModalRoute.withName('/ui/account/login')));
                //     Navigator.of(context).pushNamed("/ui/eurekoin_casino");
                //   }),
                // ),
                ListTile(
                  leading: Icon(
                    Icons.tap_and_play,
                  ),
                  title: Text(
                    "Arcade",
                  ),
                  onTap: (() {
                    Navigator.popUntil(
                        context, (ModalRoute.withName('/ui/account/login')));
                    Navigator.of(context).pushNamed("/ui/arcade_game");
                  }),
                ),
                ListTile(
                    leading: Icon(
                      Icons.access_time,
                    ),
                    title: Text(
                      "Schedule",
                    ),
                    onTap: () {
                      Navigator.popUntil(
                          context, (ModalRoute.withName('/ui/account/login')));
                      Navigator.of(context).pushNamed("/ui/schedule");
                    }),
                ListTile(
                    title: Text("Utilities",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold))),
                Divider(),
                ListTile(
                    leading: Icon(
                      Icons.score,
                    ),
                    title: Text(
                      "Scoreboard",
                    ),
                    onTap: () {
                      Navigator.popUntil(
                          context, (ModalRoute.withName('/ui/account/login')));
                      Navigator.of(context).pushNamed("/ui/scoreboard");
                    }),
                // ListTile(
                //     leading: Icon(
                //       Icons.image,
                //     ),
                //     title: Text(
                //       "Share Aarohan's Memory",
                //     ),
                //     onTap: () {
                //       Navigator.popUntil(
                //           context, (ModalRoute.withName('/ui/account/login')));
                //       Navigator.of(context).pushNamed("/ui/share_memories");
                //     }),
                ListTile(
                    leading: Icon(
                      Icons.youtube_searched_for,
                    ),
                    title: Text(
                      "Tags",
                    ),
                    onTap: () {
                      Navigator.popUntil(
                          context, (ModalRoute.withName('/ui/account/login')));
                      Navigator.of(context).pushNamed("/ui/tags");
                    }),
                // ListTile(
                //   leading: Icon(
                //     Icons.my_location,
                //   ),
                //   title: Text(
                //     "Maps",
                //   ),
                //   onTap: (() {
                //     Navigator.popUntil(
                //         context, (ModalRoute.withName('/ui/dashboard')));
                //     Navigator.of(context).push(SlideLeftRoute(widget: MapPage()));
                //   }),
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.map,
                //   ),
                //   title: Text(
                //     "Interficio",
                //   ),
                //   onTap: (() {
                //     Navigator.popUntil(
                //         context, (ModalRoute.withName('/ui/account/login')));
                //     Navigator.of(context)
                //         .pushNamed("/interficio/interficio.dart");
                //   }),
                // ),
                ListTile(
                    title: Text("Team Aavishkar",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold))),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(
                    "Sponsors",
                  ),
                  onTap: (() {
                    Navigator.popUntil(
                        context, (ModalRoute.withName('/ui/account/login')));
                    Navigator.of(context).pushNamed("/ui/sponsors/sponsors");
                  }),
                ),
                ListTile(
                    leading: Icon(
                      Icons.call,
                    ),
                    title: Text(
                      "Contact Us",
                    ),
                    onTap: () {
                      Navigator.popUntil(
                          context, (ModalRoute.withName('/ui/account/login')));
                      Navigator.of(context)
                          .pushNamed("/ui/contact_us/contact_us");
                    }),
                ListTile(
                    leading: Icon(
                      Icons.accessibility,
                    ),
                    title: Text(
                      "Contributors",
                    ),
                    onTap: () {
                      Navigator.popUntil(
                          context, (ModalRoute.withName('/ui/account/login')));
                      Navigator.of(context)
                          .pushNamed("/ui/contributors/contributors");
                    }),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About Aarohan"),
                  onTap: (() {
                    Navigator.popUntil(
                        context, (ModalRoute.withName('/ui/account/login')));
                    Navigator.of(context).pushNamed("/ui/about_us/about_us");
                  }),
                ),
                ListTile(
                  leading: Icon(Icons.power_settings_new),
                  title: Text("Logout"),
                  onTap: (() {
                    _logout();
                  }),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _gSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
      setState(() {
        previouslyLoggedIn = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
        );
      });
    });
  }

  _fSignOut() async {
    _facebookLogin.logOut();
    _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    });
  }

  Future<void> _logout() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(15),
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Alert!",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text("Do you want to Logout?"),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text("Cancel"),
                            color: Colors.red,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            child: Text("Logout"),
                            color: Colors.green,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              (currentUser.providerData[1].providerId ==
                                      "google.com")
                                  ? _gSignOut()
                                  : _fSignOut();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
