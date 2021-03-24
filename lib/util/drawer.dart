import 'package:arhn_app_2021/main.dart';
import 'package:arhn_app_2021/ui/eurekoin/eurekoin_leaderboard.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:arhn_app_2021/ui/account/login.dart';
import 'package:http/http.dart';

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
            decoration: BoxDecoration(
                /*gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF13171a),
                  Color(0xFF32393f),
                ],
                stops: [
                  0.1,
                  0.35,
                ],
              ),*/
                color: Color(0xFF292D32)),
            child: ListTileTheme(
              iconColor: Color.fromRGBO(255, 255, 255, 1.0),
              textColor: Color.fromRGBO(255, 255, 255, 1.0),
              selectedColor: Theme.of(context).primaryColor.withOpacity(1.0),
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                /*Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: currentUser != null
                      ? ListTile(
                          title: Text(
                            '${currentUser.providerData[1].displayName}',
                            style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              color: Color(0xFF6B872B),
                            ),
                          ),
                          leading: getNuUp(ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              currentUser.providerData[1].photoUrl,
                              fit: BoxFit.fill,
                            ),
                          )),
                          subtitle: Text(
                            "${currentUser.providerData[1].email}",
                            style: GoogleFonts.ubuntu(fontSize: 13),
                          ),
                        )
                      : SizedBox(),
                ),*/

                currentUser != null
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: getNuUp(ClipRRect(
                                //borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  currentUser.providerData[1].photoUrl,
                                  // fit: BoxFit.fill,
                                ),
                              )),
                            ),
                            NeumorphicButton(
                              onPressed: () {
                                _logout();
                              },
                              style: NeumorphicStyle(
                                color: Color(0xFF292D32),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(16.0),
                                ),
                                depth: 5,
                                intensity: 1,
                                lightSource: LightSource.top,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.5),
                                shadowDarkColor: Colors.black,
                              ),
                              padding: EdgeInsets.zero,
                              curve: Curves.bounceInOut,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),

                // currentUser != null?Container(
                //   height: 60,
                //   width: 60,
                //                   child: getNuUp(ClipRRect(
                //     //borderRadius: BorderRadius.circular(20),
                //     child: Image.network(
                //       currentUser.providerData[1].photoUrl,
                //      // fit: BoxFit.fill,
                //     ),
                //   )),
                // ):SizedBox(),

                getDropDownCointainer1(),
                getDropDownCointainer2(),
                getDropDownCointainer3()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget getNuUp(Widget c) {
    return Neumorphic(
        //margin: EdgeInsets.symmetric(horizontal: 10),
        style: NeumorphicStyle(
          color: Color(0xFF292D32),
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(16.0),
          ),
          depth: 5,
          intensity: 1,
          lightSource: LightSource.top,
          shadowLightColor: Colors.grey[700].withOpacity(0.5),
          shadowDarkColor: Colors.black,
        ),
        child: c);
  }

  bool isShowing = true;

  Widget getDropDownCointainer1() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick navigation",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  width: 15,
                ),
                // Icon(
                //   isShowing ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                //   color: Colors.white,
                //   size: 25,
                // )
              ],
            ),
            // onTap: () {
            //   setState(() {
            //     isShowing = !isShowing;
            //     isShowing2 = false;
            //     isShowing3 = false;
            //   });
            // },
          ),
          SizedBox(
            height: isShowing ? 10 : 0,
          ),
          isShowing
              ? getNu(Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getListItem("Dashboard", "/ui/dashboard"),
                      getListItem("Eurekoin Wallet", "/ui/eurekoin"),
                      getListItem(
                          "Eurekoin leaderboard", "/eurekoin/leader_board"),
                      getListItem("Arcade", "/ui/arcade_game"),
                      getListItem("Timeline", "/ui/schedule"),
                    ],
                  ),
                ))
              : SizedBox()
        ],
      ),
    );
  }

  // ListTile(
  //   leading: Icon(Icons.power_settings_new),
  //   title: Text("Logout"),
  //   onTap: (() {
  //     _logout();
  //   }),
  // ),

  bool isShowing2 = true;

  Widget getDropDownCointainer2() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Utilities",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  width: 15,
                ),
                // Icon(
                //   isShowing2 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                //   color: Colors.white,
                //   size: 25,
                // )
              ],
            ),
            // onTap: () {
            //   setState(() {
            //     isShowing2 = !isShowing2;
            //     isShowing = false;
            //     isShowing3 = false;
            //   });
            // },
          ),
          SizedBox(
            height: isShowing2 ? 10 : 0,
          ),
          isShowing2
              ? getNu(Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getListItem("Scoreboard", "/ui/scoreboard"),
                    ],
                  ),
                ))
              : SizedBox()
        ],
      ),
    );
  }

  bool isShowing3 = true;

  Widget getDropDownCointainer3() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Team Aavishkar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  width: 15,
                ),
                // Icon(
                //   isShowing3 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                //   color: Colors.white,
                //   size: 25,
                // )
              ],
            ),
            // onTap: () {
            //   setState(() {
            //     isShowing3 = !isShowing3;
            //     isShowing2 = false;
            //     isShowing = false;
            //   });
            // },
          ),
          SizedBox(
            height: isShowing3 ? 10 : 0,
          ),
          isShowing3
              ? getNu(Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getListItem("Sponsors", "/ui/sponsors/sponsors"),
                      getListItem("Contact Us", "/ui/contact_us/contact_us"),
                      getListItem(
                          "Contributors", "/ui/contributors/contributors"),
                      getListItem("About Aarohan", "/ui/about_us/about_us"),
                    ],
                  ),
                ))
              : SizedBox()
        ],
      ),
    );
  }

  Widget getListItem(String text, String screen) {
    return ListTile(
      onTap: () {
        // Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(screen);
      },
      title: Text(
        text,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget getNu(Widget c) {
    return Container(
      decoration: BoxDecoration(
        ///color: Color(0xFF292D32),
        border: Border.all(color: Color(0xFF1a1a1a), width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 0.0),
      child: Neumorphic(
          style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12.0),
              ),
              depth: -2.0,
              intensity: .8,
              lightSource: LightSource.topLeft,
              surfaceIntensity: .8,
              color: Color(0xFF292D32),
              shadowLightColor: Colors.black,
              shadowDarkColor:
                  Colors.black //Colors.grey[700].withOpacity(0.55),
              ),

          // width: MediaQuery.of(context).size.width * 0.7,

          child: c),
    );
  }

  _gSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
      setState(() {
        previouslyLoggedIn = true;
        Navigator.pushReplacement(
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

      Navigator.pushReplacement(
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
              child: Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(20.0),
                  ),
                  depth: 8.0,
                  intensity: 1.0,
                  lightSource: LightSource.top,
                  shadowLightColor: Colors.grey[700].withOpacity(0.55),
                  shadowDarkColor: Colors.black,
                ),
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 150,
                  decoration: BoxDecoration(
                      color: Color(0xFF292D32),
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
                            child: NeumorphicButton(
                              curve: Curves.bounceInOut,
                              child: Center(child: Text("Cancel")),
                              style: NeumorphicStyle(
                                  shadowDarkColor: Colors.black,
                                  shadowLightColor:
                                      Colors.grey[700].withOpacity(0.6),
                                  color: Colors.red,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10.0))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: NeumorphicButton(
                              child: Center(child: Text("Logout")),
                              style: NeumorphicStyle(
                                  shadowDarkColor: Colors.black,
                                  shadowLightColor:
                                      Colors.grey[700].withOpacity(0.6),
                                  color: Theme.of(context).accentColor,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10.0))),
                              onPressed: () {
                                (currentUser.providerData[1].providerId ==
                                        "google.com")
                                    ? _gSignOut()
                                    : _fSignOut();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
