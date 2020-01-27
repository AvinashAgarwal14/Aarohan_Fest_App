import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../util/drawer.dart';
import './dashboard_layout.dart';
import './newsfeed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../eurekoin/eurekoin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aavishkarapp/ui/account/login.dart';
import 'package:aavishkarapp/ui/account/account_page.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

PageController controller;

class _DashboardState extends State<Dashboard> {
  bool darkThemeEnabled = false;
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
  bool _isLoggedIn = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller = PageController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark));
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          )),
          title: Text("Aarohan"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.youtube_searched_for),
              onPressed: () {
                Navigator.of(context).pushNamed("/ui/tags");
              },
            ),
            (currentUser != null && isEurekoinAlreadyRegistered != null)
                ? IconButton(
                    icon: Image(
                        image: AssetImage("images/QRIcon.png"),
                        color: Colors.black),
                    onPressed: () {
                      if (isEurekoinAlreadyRegistered == 1) {
                        scanQR();
                      } else if (isEurekoinAlreadyRegistered == 0) {
                        scanQR();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EurekoinHomePage()),
                        ).then((onReturn) {
                          getUser();
                        });
                      }
                    })
                : Container(),
            //   SizedBox(width:10),
            // IconButton(
            //   icon:Icon(Icons.account_box),
            //   onPressed: (){
            //     _logout();
            //   },
            //   ),

            SizedBox(width: 10),
          ],
        ),
      ),
      drawer: NavigationDrawer(),
      body: Stack(
        children: <Widget>[
          DashBoardLayout(),
          SlidingUpPanel(
            color: Colors.white,
            minHeight: 65.0,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    )
                  ],
                ),
                SizedBox(height: 13.0),
                Center(
                  child: Text(
                    "Newsfeed",
                    style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      // shadows: [
                      //   BoxShadow(
                      //       color: Colors.grey[800],
                      //       offset: Offset(4.0, 4.0),
                      //       blurRadius: 15.0,
                      //       spreadRadius: 1.0),
                      //   BoxShadow(
                      //       color: Colors.white,
                      //       offset: Offset(-4.0, -4.0),
                      //       blurRadius: 15.0,
                      //       spreadRadius: 1.0),
                      // ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Newsfeed()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("Adasd");
    print(user);
    setState(() {
      currentUser = user;
    });
    if (currentUser != null) isEurekoinUserRegistered();
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
    } else
      setState(() {
        isEurekoinAlreadyRegistered = 0;
      });
  }

  Future scanQR() async {
    try {
      String hiddenString = await BarcodeScanner.scan();
      setState(() {
        barcodeString = hiddenString;
        print(barcodeString);
        Future<int> result = couponEurekoin(barcodeString);
        result.then((value) {
          print(value);
          if (value == 0) {
            setState(() {
              barcodeString = "Successful!";
            });
            showDialogBox(barcodeString);
          } else if (value == 2)
            setState(() {
              barcodeString = "Invalid Coupon";
              showDialogBox(barcodeString);
            });
          else if (value == 3)
            setState(() {
              barcodeString = "Already Used";
              showDialogBox(barcodeString);
            });
          else if (value == 4)
            setState(() {
              barcodeString = "Coupon Expired";
              showDialogBox(barcodeString);
            });
        });
      });
    } on PlatformException catch (e) {
      setState(() {
        barcodeString = 'The user did not grant the camera permission!';
        showDialogBox(barcodeString);
      });
    }
  }

  Future<void> _logout() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.indigo[400],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/sad.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Do you want to Logout?',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 16, left: 16),
                    //   child: Text('Email: ${currentUser.email}', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('CANCEL'),
                          color: Colors.white,
                          textColor: Colors.indigo[400],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (currentUser != null && userProfile == null)
                              _gSignOut();
                            else if (userProfile != null &&
                                currentUser == null) {
                              _fSignOut();
                              print("Logout!");
                            }
                          },
                          child: Text('LOGOUT'),
                          textColor: Colors.indigo[400],
                          color: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
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
      _isLoggedIn = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
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
    database
        .reference()
        .child("Profiles")
        .update({"${user.uid}": "${user.email}"});
    print("User: $user");
    return user;
  }

  Future<int> _fSignIn() async {
    FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
    final accessToken = facebookLoginResult.accessToken.token;
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${accessToken}');
      final profile = JSON.jsonDecode(graphResponse.body);
      print(profile);
      setState(() {
        userProfile = profile;
        _isLoggedIn = true;
      });

      print("User : ");
      return 1;
    } else
      return 0;
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  void showDialogBox(String message) {
    // flutter defined function
    print("$message");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("QR Code Result"),
          content: new Text("$message"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> couponEurekoin(String coupon) async {
    var email = currentUser.email;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);
    String apiUrl =
        "https://ekoin.nitdgplug.org/api/coupon/?token=$encoded&code=$coupon";
    http.Response response = await http.get(apiUrl);
    print(response.body);
    var status = json.decode(response.body)['status'];
    return int.parse(status);
  }
}
