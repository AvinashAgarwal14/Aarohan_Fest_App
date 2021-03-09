import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import './loginAnimation.dart';
import 'package:flutter/animation.dart';
import './styles.dart';
import '../../util/event_details.dart';
import '../../util/detailSection.dart';
import '../../util/drawer.dart';
import 'package:arhn_app_2021/ui/account/login.dart';

class Account_Page extends StatefulWidget {
  @override
  _Account_PageState createState() => _Account_PageState();
}

class _Account_PageState extends State<Account_Page> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  int click = 0, gclick = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser currentUser;

  bool previouslyLoggedIn = false;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    currentUser = await _auth.currentUser();
    setState(() {});
  }

  var animationStatus = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
      new SliverAppBar(
        expandedHeight: _appBarHeight,
        pinned: _appBarBehavior == AppBarBehavior.pinned,
        floating: _appBarBehavior == AppBarBehavior.floating ||
            _appBarBehavior == AppBarBehavior.snapping,
        snap: _appBarBehavior == AppBarBehavior.snapping,
        flexibleSpace: new FlexibleSpaceBar(
          title: Text('Profile'),
          background: new Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.loose,
            children: <Widget>[
              CircleAvatar(
                radius: animationStatus == 1 ? 60.0 : 42.0,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.black12,
              ),
              Container(
                  width: animationStatus == 1 ? 120.0 : 80.0,
                  height: animationStatus == 1 ? 120.0 : 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(currentUser.photoUrl)))),

              CircleAvatar(
                child: new Image.network(
                  "${currentUser.photoUrl}",
                  fit: BoxFit.scaleDown,
                  //height: _appBarHeight,
                ),
                backgroundColor: Colors.white,
                radius: animationStatus == 2 ? 45.0 : 80.0,
              ),
              //maxRadius:10

              // This gradient ensures that the toolbar icons are distinct
              // against the background image.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.6),
                    end: Alignment(0.0, -0.4),
                    colors: <Color>[Color(0x60000000), Color(0x00000000)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      new SliverList(
          delegate: new SliverChildListDelegate(<Widget>[
        _card('Name', '${currentUser.displayName}', Icon(Icons.person)),
        _card('Email', '${currentUser.email}', Icon(Icons.email)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/ui/eurekoin");
          },
          child: _card('Eurekoin wallet', '', Icon(Icons.videogame_asset)),
        ),
        // GestureDetector(
        //   onTap: () {
        //     if (currentUser.providerData[1].providerId ==
        //         "google.com")
        //       _gSignOut();
        //     else
        //     print("Logout!");
        //   },
        //   child: DetailCategory(
        //     icon: Icons.remove_circle,
        //     children: <Widget>[
        //       DetailItem(
        //         lines: <String>['Logout'],
        //       )
        //     ],
        //   ),
        // )
      ]))
    ]));
  }

  _gSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
    });
  }

  Widget _card(String mainheading, String subheading, Widget _icon) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white10.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _icon,
              SizedBox(
                width: 15,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$mainheading',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18)),
                    Text('$subheading',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
