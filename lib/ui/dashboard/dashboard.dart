import 'dart:async';
import 'package:crypto/crypto.dart';
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

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  
    

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    getUser();
  }
  initUser() async{
    currentUser= await _auth.currentUser();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
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
                          }}
                      )
                        :
                        Container(),
                      
                      SizedBox(width:10),
                      IconButton(
                        icon:Icon(Icons.power_settings_new),
                        onPressed: (){
                          setState((){
                            _logout();
                            
                          }
                          );
                        },
                        ),

                      SizedBox(width:10),
                  ],
                )
      ),
      drawer: NavigationDrawer(),
      body: Stack(
        children: <Widget> [
          DashBoardLayout(),
          SlidingUpPanel(
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
                    Center(child: Text("Newsfeed")),
                    SizedBox(height: 20.0),
                    Container(
                        padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Newsfeed()),
                  ]))
        ]));
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
      borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/sad.png', height: 120, width: 120,),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        SizedBox(height: 24,),
        Text('Do you want to Logout?', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Text('Email: ${currentUser.email}', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('CANCEL'),color: Colors.white, textColor: Colors.indigo[400],),
            SizedBox(width: 8,),
            RaisedButton(onPressed: (){
              _gSignOut();
            }, child: Text('LOGOUT'),textColor: Colors.indigo[400],color: Colors.white, )
          ],
        )
      ],
    ),
  )
            
            );
      });
  
  
  
  
  
  // <void>(
  //   context: context,
  //   barrierDismissible: true, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //         elevation: 100,
  //       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       title: Text('Logout'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: <Widget>[
  //             Text('${currentUser.email}')
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //           child: Text('Cancel'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         FlatButton(
  //           child: Text('Logout'),
  //           onPressed: () {
              
  //             _gSignOut();
  //             },
  //         ),
  //           ],
  //         )
  //       ],
  //     );
  //   },
  // );
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


  _gSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      previouslyLoggedIn = true;
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()),);
            
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
