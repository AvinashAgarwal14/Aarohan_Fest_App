import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/rendering.dart';

import './pages/home_page.dart';
import './pages/authentication.dart';

import 'package:firebase_database/firebase_database.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> user = {
    "name": "",
    "username": "",
    "token": "",
    "isAuthenticated": false,
    "email": "",
    "password": ""
  };

  bool _isLoading = false;

  void autoAuthenticate() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear(); //remove this to save user data
    var _token = prefs.getString("token");
    print(_token);
    if (_token != null) {
      setState(() {
        user["isAuthenticated"] = true;
        user["username"] = prefs.getString("username");
        user["token"] = prefs.getString("token");
        user["email"] = prefs.getString("email");
        user["password"] = prefs.getString("password");
        user["name"] = prefs.getString("name");
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReference;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool comingsoon = false;

  void _onEntryUpdated(Event event) {
    setState(() {
      print(event.snapshot.value);
      comingsoon = event.snapshot.value;
      print(comingsoon);
    });
  }

  @override
  void initState() {
    autoAuthenticate();
    // _databaseReference = _database.reference().child("comingsoon");
    // _databaseReference.onChildChanged.listen(_onEntryUpdated);
    // _databaseReference.child("JD").once().then((snapshot) {
    //   setState(() {
    //     comingsoon = snapshot.value;
    //   });
    //   print(comingsoon);
    // });

    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark));
        Navigator.pop(context);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.red,
            accentColor: Colors.black),
        routes: {
          "/": (BuildContext context) => _isLoading
              ? Container()
              : comingsoon
                  ? Scaffold(
                      body: Material(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset("images/comingsoon.png",
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : user["isAuthenticated"]
                      ? HomePage(user)
                      : AuthPage(user),
        },
      ),
    );
  }
}
