import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './loginAnimation.dart';
import 'package:flutter/animation.dart';
import './styles.dart';
import '../../util/event_details.dart';
import 'package:arhn_app_2021/ui/dashboard/dashboard.dart';
import '../../util/drawer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';

var kFontFam = 'CustomFonts';
var firebaseAuth = FirebaseAuth.instance;

IconData github_circled = IconData(0xe800, fontFamily: kFontFam);
IconData linkedin = IconData(0xe801, fontFamily: kFontFam);
IconData facebook = IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);

class LogInPage extends StatefulWidget {
  @override
  State createState() => new LogInPageState();
}

class LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  int click = 0, gclick = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser currentUser;
  Map userProfile;
  bool _isLoggedIn = false;

  bool previouslyLoggedIn = false;
  AnimationController _glogInButtonController;
  AnimationController _flogInButtonController;
  var animationStatus = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark));
    super.initState();

    // Check whether user is currently logged in
    getUser();

    //Button Controller for google login
    _glogInButtonController = new AnimationController(
        duration: new Duration(milliseconds: 1700),
        vsync: this,
        debugLabel: "google");
    //Button Controller for Facebook login
    _flogInButtonController = new AnimationController(
        duration: new Duration(milliseconds: 1700),
        vsync: this,
        debugLabel: "facebook");
  }

  // Animation that comes when sign in is clicked
  Future<Null> _playAnimation(int n) async {
    try {
      if (n == 1) {
        print("BLOCK 31");
        await _glogInButtonController.forward();
        print("BLOCK 31");
        setState(() {});
      } else if (n == 2) {
        print("BLOCK 331");
        await _flogInButtonController.forward();
        setState(() {});
      }
    } on TickerCanceled {}
  }

  // Reverse the animation when logout button is clicked
  Future<Null> _reverseAnimation(int n) async {
    try {
      if (n == 1) {
        print("BLOCK 51");
        await _glogInButtonController.reverse();
        print("BLOCK 52");
        setState(() {
          print("BLOCK 52");
          animationStatus = 0;
          currentUser = null;
        });
      } else if (n == 2) {
        await _flogInButtonController.reverse();
        //await _glogInButtonController.reverse();
        setState(() {
          animationStatus = 0;
          currentUser = null;
        });
      }
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null && userProfile == null) {
      return new Scaffold(
          body: WillPopScope(
              onWillPop: _exit,
              child: Container(
                  decoration: new BoxDecoration(
                    image: backgroundImage,
                  ),
                  child: new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      //               decoration: new BoxDecoration(
                      //         gradient: new LinearGradient(
//                    colors: <Color>[
//                      const Color.fromRGBO(162, 146, 199, 0.4),
//                      const Color.fromRGBO(51, 51, 63, 0.4),
//                    ]
//                    stops: [0.2, 1.0],
//                    begin: const FractionalOffset(0.0, 0.0),
//                    end: const FractionalOffset(0.0, 1.0),
                      //  )
                      //),
                      child: new ListView(
                        padding: const EdgeInsets.all(0.0),
                        children: <Widget>[
                          new Stack(
                              alignment: (animationStatus == 0)
                                  ? FractionalOffset.center
                                  : FractionalOffset.center,
                              children: <Widget>[
//                            animationStatus == 0
//                                ?
                                SizedBox(
                                    height: MediaQuery.of(context).size.height),
                                animationStatus == 0
                                    ? (Container(
                                        child: new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
//                                  SizedBox(
//                                      height: MediaQuery.of(context)
//                                          .size
//                                          .height /
//                                          3),
                                            new Padding(
                                              padding: const EdgeInsets.only(),
                                              child: new InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      animationStatus = 1;
                                                    });
                                                  },
                                                  child: signIn(
                                                      "Sign in with Google")),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Center(
                                                  child: Text(
                                                "OR",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              )),
                                            ),
                                            new Padding(
                                              padding: const EdgeInsets.only(),
                                              child: new InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      animationStatus = 2;
                                                    });
                                                  },
                                                  child: signIn(
                                                      "Sign in with Facebook!")),
                                            ),
                                          ])))
                                    : FutureBuilder(
                                        future: animationStatus == 1
                                            ? _gSignIn()
                                            : _gSignIn(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (currentUser == null &&
                                              userProfile == null) {
                                            print("---------Gangnum");
                                            return animationStatus == 1
                                                ? Container(
                                                    child:
                                                        CircularProgressIndicator(
                                                    value: null,
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ))
                                                : Container();
                                          } else {
                                            _playAnimation(animationStatus);
                                            return new StaggerAnimation(
                                                buttonController:
                                                    animationStatus == 2
                                                        ? _flogInButtonController
                                                            .view
                                                        : _glogInButtonController
                                                            .view);
                                          }
                                        })
                              ])
                        ],
                      )))));
    } else {
      return Dashboard();
    }
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      setState(() {
        currentUser = user;

        animationStatus = 0;
      });
    } else {
      setState(() {
        currentUser = user;
        if (user.providerData[1].providerId == "google.com") {
          //print(user.providerData[1]);
          animationStatus = 1;
          _playAnimation(1);
        } else {
          animationStatus = 2;
          _playAnimation(2);
        }
      });
    }
  }

  _gSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
    });
  }

  _fSignOut() async {
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
    });
  }

  Future _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    currentUser = user;
    database.reference().child("Profiles").update(
        {"${user.providerData[1].uid}": "${user.providerData[1].email}"});
    print("User: $user");
    return user;
  }

//  addStringToSF() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString("email id", "abc");
//  }

  signIn(String str) {
    return (new Container(
      width: MediaQuery.of(context).size.width - 80.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(123, 123, 123, 1.0),
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            // child: Image( image: str.contains("Google")?AssetImage("images/googleicon.jpg"):AssetImage("images/facebookicon.jpg"),),
            child: str.contains("Google")
                ? Icon(
                    google,
                  )
                : Icon(
                    facebook,
                  ),
          ),
          Text(
            str,
            maxLines: 1,
            style: new TextStyle(
              color: Color.fromRGBO(240, 240, 240, 1.0),
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    ));
  }

  Future<bool> _exit() async {
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
                      child: Text("Do you want to Exit?"),
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
                            child: Text("Exit"),
                            color: Colors.green,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              exit(0);
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
