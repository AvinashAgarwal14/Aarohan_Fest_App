import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class Contributors extends StatefulWidget {
  @override
  _ContributorsState createState() => _ContributorsState();
}

var kFontFam = 'CustomFonts';

IconData github_circled = IconData(0xe800, fontFamily: kFontFam);
IconData linkedin = IconData(0xe801, fontFamily: kFontFam);
IconData facebook = IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

double value = 0;

//TODO Data Entry
Map contributors = {
  // sudipta da
  "Name": [
    "Souparno Paul",
    "Anurag Mondal",
    "Nikhil Kumar",
    "Subhadip Rudra",
    "Jyotishka Dasgupta",
    "Romit Karmakar",
    "Simran Singh",
    "Avinash Agarwal",
    "Akshat Jain",
  ],
  "ProfilesFacebook": [
    "https://www.facebook.com/souparno.paul.1",
    "https://www.facebook.com/anurag.mondal.5623293",
    "https://www.facebook.com/nikhil.me.nk05062001",
    "https://www.facebook.com/subhadip.rudra.5",
    "https://www.instagram.com/jyotishka_dasgupta/",
    "https://www.facebook.com/romitkarmakar123",
    "https://www.facebook.com/simran9907",
    "https://www.facebook.com/avinash.agarwal.1614",
    "https://www.facebook.com/akshat.jain.336333",
  ],
  "ProfilesGithub": [
    "https://github.com/Soupaul",
    "https://github.com/knightvertrag",
    "https://github.com/kumanik5661",
    "https://github.com/subhadiprudra",
    "https://github.com/phoenix7139",
    "https://github.com/romitkarmakar",
    "https://github.com/simran9928",
    "https://github.com/AvinashAgarwal14",
    "https://github.com/Akshat7321",
  ],
  "ProfilesLinkedin": [
    "https://www.linkedin.com/in/souparno-paul-b999a41ab",
    "https://www.linkedin.com/in/anurag-mondal-8b8b2410a/",
    "https://www.linkedin.com/in/nikhil-kumar-129978178",
    "https://www.linkedin.com/in/subhadip-rudra-96b2491b2",
    "https://www.linkedin.com/in/jyotishka-dasgupta-7a2a1217b/",
    "https://www.linkedin.com/in/romit-karmakar-777662131/",
    "https://www.linkedin.com/in/simran-singh-aa4bb5184",
    "https://www.linkedin.com/in/agarwalavinash14/",
    "https://www.linkedin.com/in/akshat-jain-007365a2/",
  ],
  "Contact": [
    "+91 9830449178",
    "+91 9748323504",
    "+91 7980592059",
    "+91 9851695323",
    "+91 9163479911",
    "+91 6295722469",
    "+91 7595932690",
    "+91 8981866219",
  ],
  "Image": [
    "images/Contributors/souparno.jpeg",
    "images/Contributors/anurag.jpeg",
    "images/Contributors/nikhil.jpg",
    "images/Contributors/subhadip.jpg",
    "images/Contributors/Jyotishka.jpg",
    "images/Contributors/romit.jpg",
    "images/Contributors/simran.jpeg",
    "images/Contributors/avinash.jpeg",
    "images/Contributors/akshat.jpg",
  ],
};

class _ContributorsState extends State<Contributors> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  Widget separator;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // SystemChrome.setSystemUIOverlayStyle(
        //   SystemUiOverlayStyle(
        //       statusBarColor: Colors.white,
        //       systemNavigationBarIconBrightness: Brightness.dark),
        // );
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavigationDrawer(),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        NeumorphicButton(
                          margin: EdgeInsets.only(top: 5.0, left: 10.0),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          padding: EdgeInsets.all(0),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 7.5,
                            intensity: 1.0,
                            lightSource: LightSource.topLeft,
                            shadowLightColor: Colors.grey[700].withOpacity(0.6),
                            shadowDarkColor: Colors.black,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF63d471).withOpacity(0.5),
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF396b4b),
                                  Color(0xFF78e08f),
                                ],
                              ),
                            ),
                            height: 50.0,
                            width: 50.0,
                            child: Center(
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                // size: 25,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50.0, 10.0, 30.0, 0.0),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              "Contributors",
                              style: GoogleFonts.josefinSans(
                                  fontSize: 30,
                                  color: Colors.white //(0xFF6B872B),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 6 / 10,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Neumorphic(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 10.0,
                                intensity: 1.0,
                                lightSource: LightSource.topLeft,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.6),
                                shadowDarkColor: Colors.black,
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF292D32),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 1.5,
                                      color: Colors.grey[700].withOpacity(0.3),
                                    ),
                                  ),
                                  //margin: new EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  contributors["Image"][index],
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xff03A062),
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                              ),
                                              padding: EdgeInsets.all(5),
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                contributors["Name"][index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                child: IconButton(
                                                  icon: Icon(
                                                    facebook,
                                                  ),
                                                  disabledColor: Colors.black,
                                                  color: Colors.blueAccent,
                                                  onPressed: () {
                                                    _launchURL(contributors[
                                                            "ProfilesFacebook"]
                                                        [index]);
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  linkedin,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  _launchURL(contributors[
                                                          "ProfilesLinkedin"]
                                                      [index]);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                github_circled,
                                                color: Color.fromRGBO(
                                                    201, 81, 12, 1.0),
                                              ),
                                              onPressed: () {
                                                _launchURL(contributors[
                                                    "ProfilesGithub"][index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.call),
                                              color: Colors.green,
                                              onPressed: () {
                                                launch("tel:" +
                                                    contributors["Contact"]
                                                        [index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      ])),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String str) async {
    if (await canLaunch(str)) {
      await launch(str);
    } else {
      throw 'Could not launch $str';
    }
  }
}

/*

Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          // fit: StackFit.expand,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              //color: Colors.black,
                              //height: MediaQuery.of(context).size.height / 3,
                              //width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                contributors["Image"][index],
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                gradient: new LinearGradient(
                                  colors: <Color>[
                                    const Color.fromRGBO(255, 255, 255, 0.2),
                                    const Color.fromRGBO(0, 0, 0, 0.7),
                                  ],
                                  stops: [0.2, 1.0],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(0.0, 1.0),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              height: 80.0,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 3 -
                                      80.0),
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      contributors["Name"][index],
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: IconButton(
                                          icon: Icon(
                                            facebook,
                                          ),
                                          disabledColor: Colors.black,
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            _launchURL(
                                                contributors["ProfilesFacebook"]
                                                    [index]);
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          linkedin,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          _launchURL(
                                              contributors["ProfilesLinkedin"]
                                                  [index]);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );

IconButton(
                                        icon: Icon(
                                          github_circled,
                                          color:
                                              Color.fromRGBO(201, 81, 12, 1.0),
                                        ),
                                        onPressed: () {
                                          _launchURL(
                                              contributors["ProfilesGithub"]
                                                  [index]);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.call),
                                        color: Colors.green,
                                        onPressed: () {
                                          launch("tel:" +
                                              contributors["Contact"][index]);
                                        },
                                      ),*/
