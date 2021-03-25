import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/drawer2.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var kFontFam = 'CustomFonts';
var whatsappFontFam = 'WhatsappIcon';

IconData whatsapp = IconData(0xf232, fontFamily: whatsappFontFam);

IconData github_circled = IconData(0xe800, fontFamily: kFontFam);
IconData linkedin = IconData(0xe801, fontFamily: kFontFam);
IconData facebook = IconData(0xf052, fontFamily: kFontFam);
IconData google = IconData(0xf1a0, fontFamily: kFontFam);
IconData facebook_1 = IconData(0xf300, fontFamily: kFontFam);

Color borderColor = Color(0xff03bc72);
var borderWid = 2.0;

// class ContactUs extends StatefulWidget {
//   @override
//   _ContactUsState createState() => _ContactUsState();
// }

// class _ContactUsState extends State<ContactUs> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //        backgroundColor: Theme.of(context).brightness==Brightness.light?Colors.white70:Colors.black38,
//         drawer: NavigationDrawer(),
//         appBar: AppBar(
//           title: Text("Contact Us"),
//         ),
//         body: OrientationBuilder(builder: (context, orientation) {
//           return GridView.count(
//               crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
//               cacheExtent: MediaQuery.of(context).size.height,
//               padding: EdgeInsets.all(8.0),
//               children: List.generate(16, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Stack(
//                       fit: StackFit.expand,
//                       children: <Widget>[
//                         Container(
//                         child: Image.asset(contactCard["Image"][index],
//                             fit: BoxFit.cover)),
//                     Container(
//                       height: 100.0,
//                       margin: EdgeInsets.only(top: 98.0),
//                       color: Color.fromRGBO(0, 0, 0, 0.65),
//                       child:
//                           Column(
//                             //mainAxisSize: MainAxisSize.min,
//                            // crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   contactCard["User"][index],
//                                   style: TextStyle(
//                                       fontSize: 13.0, color: Colors.white),
//                                 ),
//                                 Text(contactCard["Designation"][index],
//                                     style: TextStyle(
//                                         fontSize: 10.0, color: Colors.white70)),
//                           Row(
// //                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                            crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Flexible(
//   child: IconButton(
//     //padding: EdgeInsets.all(0.0),
//     iconSize: 15.0,
//     icon: Icon(
//       facebook,
//       color: Colors.grey
//     ),
//     disabledColor: Colors.black,
//     color: Colors.blueAccent,
//     onPressed: () {
//       _launchURL(
//           contactCard["ProfilesFacebook"][index]);
//     },
//   ),
// ),
//                               IconButton(
//                                 //padding: EdgeInsets.all(0.0),
//                                 iconSize: 15.0,
//                                 icon: Icon(
//                                   linkedin,
//                                   color: Colors.grey
//                                 ),
//                                 onPressed: () {
//                                   _launchURL(
//                                       contactCard["ProfilesLinkedin"][index]);
//                                 },
//                               ),
//                               IconButton(
//                                 //padding: EdgeInsets.all(0.0),
//                                 iconSize: 15.0,
//                                 icon: Icon(whatsapp, color: Colors.grey),
//                                 onPressed: () {
//                                   _launchWhatsapp(
//                                       contactCard["ProfilesWhatsapp"][index]);
//                                 },
//                               ),
//                               IconButton(
//                                // padding: EdgeInsets.all(0.0),
//                                 iconSize: 15.0,
//                                 icon: Icon(Icons.call, color: Colors.grey),
//                                 onPressed: () {
//                                   launch(
//                                       "tel:" + contactCard["Contact"][index]);
//                                 },
//                               ),
//                             ],
//                           ),
//                               ],
//                           ),
//                     )
//                   ]),
//                 );
//               }));
//         }));
//   }

// _launchURL(String str) async {
//   if (await canLaunch(str)) {
//     await launch(str);
//   } else {
//     throw 'Could not launch $str';
//   }
// }

//   _launchWhatsapp(String str) async {
//     var whatsappUrl = "whatsapp://send?phone=$str";
//     await canLaunch(whatsappUrl)
//         ? launch(whatsappUrl)
//         : print(
//             "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
//   }
// }

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

Map contactCard = {
  "OverallCoordinator": [
    "Liman Rahman",
    "Shashwat Bhattacharjee",
    "Nikhil Vashistha",
    "Aadarsh Shaw",
    "Utkarsh Chaurasia"
  ],
  "GeneralSecretary": [
    "Ayush Kumar Shukla",
    "Soumik Paul",
    "Swaraj Agrawal",
    "Manish Awasthi",
    "Akshat Jain"
  ],
  "Treasurer": [
    "Avinash Prasad",
    "Bhavesh Chandwani",
    "Sparsh Kedia",
    "Riddhiman Sanyal",
  ],
  "CorporateCommunication": [
    "Akshat Jain",
    "Raman Kapri",
    "Jaideep Datta",
    "Sakchi Agarwal"
  ],
  "POC": ["9475522304", "9163322604", "9835274836", "9832509202", "7355399636"],
  "PGS": ["8001507060", "9593493630", "9407256919", "8436336451", "8004937056"],
  "PCC": ["8004937056", "9002726215", "9002198118", "7044988664"],
  "PT": ["8617671512", "7355722096", "8100553002", "8670052205"],
  "FOC": [
    "https://www.facebook.com/liman.rahman.1",
    "https://www.facebook.com/shashwat.bhattacharjee",
    "https://www.facebook.com/nikhil.vashistha.12",
    "null",
    "https://www.facebook.com/prosperous.uttkarsh",
  ],
  "FGS": [
    "https://www.facebook.com/profile.php?id=100011461941432",
    "https://m.facebook.com/soumik.paul.503",
    "https://www.facebook.com/swaraj.agrawal.33",
    "https://www.facebook.com/manish.awasthi.2408",
    "https://www.facebook.com/akshat.jain.336333"
  ],
  "FT": [
    "https://www.facebook.com/avinash.prasad.1238",
    "https://www.facebook.com/profile.php?id=100009740767459",
    "null",
    "null"
  ],
  "FCC": [
    "https://www.facebook.com/akshat.jain.336333",
    "https://m.facebook.com/Raman1309?ref=bookmarks",
    "https://www.facebook.com/jaideep.datta.31",
    "null"
  ],
  "ICC": [
    "assets/akshat.jpg",
    "assets/CC2.jpg",
    "assets/CC3.JPG",
    "assets/CC4.jpg",
  ],
  "IT": [
    "assets/T1.jpg",
    "assets/T2.jpg",
    "assets/T3.jpg",
    "assets/T4.jpg",
  ],
  "IGS": [
    "assets/GS1.jpg",
    "assets/GS2.jpeg",
    "assets/GS3.jpg",
    "assets/GS4.jpg",
    "assets/akshat.jpg",
  ],
  "IOC": [
    "assets/OC1.jpg",
    "assets/OC2.jpg",
    "assets/OC3.png",
    "assets/OC4.jpg",
    "assets/OC5.jpg",
  ],
};

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      drawer: NavigationDrawer("${ModalRoute.of(context).settings.name}"),

      // appBar: AppBar(backgroundColor: Colors.transparent,),
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
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
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
                        Expanded(
                          child: Container(
                            // color: Colors.black,
                            // padding: EdgeInsets.fromLTRB(50.0, 10.0, 30.0, 0.0),
                            child: Center(
                              child: Text(
                                "Contact Us",
                                style: GoogleFonts.josefinSans(
                                    fontSize: 30,
                                    color: Colors.white //(0xFF6B872B),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      // color: Colors.black,
                      // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "Overall Coordinator",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                // shadows: [
                                //   BoxShadow(
                                //       color: Colors.grey[800],
                                //       offset: Offset(2.0, 2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                //   BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(-2.0, -2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                // ],
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            height: 305.0,
                            // width: MediaQuery.of(context).size.width-10.0,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              cacheExtent: 1350.0,
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Neumorphic(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                    height: 100.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF292D32),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 1.5,
                                        color:
                                            Colors.grey[700].withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            height: 150.0,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                    contactCard["IOC"][index],
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover))),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Column(children: <Widget>[
                                            Text(
                                              contactCard["OverallCoordinator"]
                                                  [index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(Icons.call,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          contactCard["POC"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    //padding: EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(facebook,
                                                        color: Colors.white),
                                                    disabledColor: Colors.black,
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      _launchURL(
                                                          contactCard["FOC"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "General Secretary",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                // shadows: [
                                //   BoxShadow(
                                //       color: Colors.grey[800],
                                //       offset: Offset(2.0, 2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                //   BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(-2.0, -2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                // ],
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            height: 305.0,
                            // width: MediaQuery.of(context).size.width-10.0,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              cacheExtent: 1350.0,
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Neumorphic(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                    height: 100.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF292D32),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 1.5,
                                        color:
                                            Colors.grey[700].withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            height: 150.0,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                    contactCard["IGS"][index],
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover))),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Column(children: <Widget>[
                                            Text(
                                              contactCard["GeneralSecretary"]
                                                  [index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(Icons.call,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          contactCard["PGS"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    //padding: EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(facebook,
                                                        color: Colors.white),
                                                    disabledColor: Colors.black,
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      _launchURL(
                                                          contactCard["FGS"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "Treasurer",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                // shadows: [
                                //   BoxShadow(
                                //       color: Colors.grey[800],
                                //       offset: Offset(2.0, 2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                //   BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(-2.0, -2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                // ],
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            height: 305.0,
                            // width: MediaQuery.of(context).size.width-10.0,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              cacheExtent: 1350.0,
                              itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Neumorphic(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                    height: 100.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF292D32),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 1.5,
                                        color:
                                            Colors.grey[700].withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            height: 150.0,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                    contactCard["IT"][index],
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover))),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Column(children: <Widget>[
                                            Text(
                                              contactCard["Treasurer"][index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(Icons.call,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          contactCard["PT"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    //padding: EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(facebook,
                                                        color: Colors.white),
                                                    disabledColor: Colors.black,
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      _launchURL(
                                                          contactCard["FT"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "Corporate Communication",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                // shadows: [
                                //   BoxShadow(
                                //       color: Colors.grey[800],
                                //       offset: Offset(2.0, 2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                //   BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(-2.0, -2.0),
                                //       blurRadius: 10.0,
                                //       spreadRadius: 1.0),
                                // ],
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            height: 305.0,
                            width: MediaQuery.of(context).size.width - 10.0,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              cacheExtent: 1350.0,
                              itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Neumorphic(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                    height: 100.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF292D32),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 1.5,
                                        color:
                                            Colors.grey[700].withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            height: 150.0,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                    contactCard["ICC"][index],
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover))),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Column(children: <Widget>[
                                            Text(
                                              contactCard[
                                                      "CorporateCommunication"]
                                                  [index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(Icons.call,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          contactCard["PCC"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    //padding: EdgeInsets.all(0.0),
                                                    iconSize: 15.0,
                                                    icon: Icon(facebook,
                                                        color: Colors.white),
                                                    disabledColor: Colors.black,
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      _launchURL(
                                                          contactCard["FCC"]
                                                              [index]);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
