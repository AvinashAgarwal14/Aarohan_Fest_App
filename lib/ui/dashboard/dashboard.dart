import 'dart:async';
import 'package:arhn_app_2021/model/date_model.dart';
import 'package:arhn_app_2021/model/event.dart';
import 'package:arhn_app_2021/model/event_type_model.dart';
import 'package:arhn_app_2021/model/events_model.dart';
import 'package:arhn_app_2021/ui/account/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show SystemChrome, rootBundle;
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../util/drawer.dart';
import './dashboard_layout.dart';
import './newsfeed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import '../eurekoin/eurekoin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arhn_app_2021/data/data.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

PageController controller;

class _DashboardState extends State<Dashboard> {
  List<DateModel> dates = new List<DateModel>();
  List<EventTypeModel> eventsType = new List();
  EventResponse res;
  List<EventItem> events;
  // List<EventsModel> events = new List<EventsModel>();
  String todayDateIs = "12";

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

    getJSON().then((value) {
      print(json.decode(value));
      res = EventResponse.fromJSON(json.decode(value));
      setState(() {
        events = res.events;
      });
    });

    dates = getDates();
    eventsType = getEventTypes();
    // events = getEvents();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller = PageController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark));
    getUser();
  }

  Future getJSON() {
    return rootBundle.loadString('aarohan_events.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          title: Text(
            "Aarohan",
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.youtube_searched_for),
              onPressed: () {
                Navigator.of(context).pushNamed("/ui/tags");
              },
            ),
            (currentUser != null && isEurekoinAlreadyRegistered != null)
                ? IconButton(
                    color: Colors.black,
                    icon: Image(
                      image: AssetImage("images/QRIcon.png"),
                      color: Colors.black,
                    ),
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
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.black),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Dates
                    Container(
                      height: 100,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          itemCount: dates.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return DateTile(
                              weekDay: dates[index].weekDay,
                              date: dates[index].date,
                              isSelected: todayDateIs == dates[index].date,
                            );
                          }),
                    ),

                    /// Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "All Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: eventsType.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return EventTile(
                              imgAssetPath: eventsType[index].imgAssetPath,
                              eventType: eventsType[index].eventType,
                            );
                          }),
                    ),

                    /// Popular Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Popular Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Container(
                      height: 300.0,
                      child: events != null
                          ? ListView.builder(
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                return PopularEventTile(
                                  desc: events[index].title,
                                  imgeAssetPath: events[index].imageUrl,
                                  date: events[index].date,
                                  address: events[index].location,
                                );
                              },
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // body: Stack(
      //   children: <Widget>[
      //     DashBoardLayout(),
      //     SlidingUpPanel(
      //       color: Colors.white,
      //       minHeight: 65.0,
      //       maxHeight: MediaQuery.of(context).size.height * 0.85,
      //       panel: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           SizedBox(height: 5.0),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Container(
      //                 width: 35,
      //                 height: 8,
      //                 decoration: BoxDecoration(
      //                     color: Colors.grey[300],
      //                     borderRadius:
      //                         BorderRadius.all(Radius.circular(12.0))),
      //               )
      //             ],
      //           ),
      //           SizedBox(height: 13.0),
      //           Center(
      //             child: Text(
      //               "Newsfeed",
      //               style: TextStyle(
      //                 fontSize: 21.0,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.grey[800],
      //                 // shadows: [
      //                 //   BoxShadow(
      //                 //       color: Colors.grey[800],
      //                 //       offset: Offset(4.0, 4.0),
      //                 //       blurRadius: 15.0,
      //                 //       spreadRadius: 1.0),
      //                 //   BoxShadow(
      //                 //       color: Colors.white,
      //                 //       offset: Offset(-4.0, -4.0),
      //                 //       blurRadius: 15.0,
      //                 //       spreadRadius: 1.0),
      //                 // ],
      //               ),
      //             ),
      //           ),
      //           SizedBox(height: 20.0),
      //           Container(
      //               padding: const EdgeInsets.only(left: 14.0, right: 14.0),
      //               height: MediaQuery.of(context).size.height * 0.75,
      //               child: Newsfeed()),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("Adasd");
    print(user);
    setState(() {
      currentUser = user;
    });
    // if (currentUser != null) isEurekoinUserRegistered(); Eurekoin endpoint down
  }

  Future isEurekoinUserRegistered() async {
    var email = currentUser.providerData[1].email;
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
      if (hiddenString.contains("arhn")) {
        hiddenString = hiddenString.substring(11, hiddenString.length);

        await launch(hiddenString);
        hiddenString = hiddenString.substring(0, hiddenString.length - 15) +
            "2" +
            hiddenString.substring(hiddenString.length - 14);
        await launch(hiddenString);
        hiddenString = hiddenString.substring(0, hiddenString.length - 15) +
            "3" +
            hiddenString.substring(hiddenString.length - 14);
        await launch(hiddenString);
//        } else {
//          throw 'Could not launch $hiddenString';
//        }
      } else {
        setState(
          () {
            barcodeString = hiddenString;
            print(barcodeString);
            Future<int> result = couponEurekoin(barcodeString);
            result.then(
              (value) {
                print(value);
                if (value == 0) {
                  setState(
                    () {
                      barcodeString = "Successful!";
                    },
                  );
                  showDialogBox(barcodeString);
                } else if (value == 2)
                  setState(
                    () {
                      barcodeString = "Invalid Coupon";
                      showDialogBox(barcodeString);
                    },
                  );
                else if (value == 3)
                  setState(
                    () {
                      barcodeString = "Already Used";
                      showDialogBox(barcodeString);
                    },
                  );
                else if (value == 4)
                  setState(
                    () {
                      barcodeString = "Coupon Expired";
                      showDialogBox(barcodeString);
                    },
                  );
              },
            );
          },
        );
      }
    } on PlatformException catch (e) {
      setState(() {
        barcodeString = 'The user did not grant the camera permission!';
        showDialogBox(barcodeString);
      });
    }
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
    var email = currentUser.providerData[1].email;
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

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffffd530) : Color(0xff29404E),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xffFCCD00),
                    spreadRadius: 4,
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Color(0xffFCCD00),
                    spreadRadius: -4,
                    blurRadius: 5,
                  ),
                ]
              : []),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String imgeAssetPath;

  /// later can be changed with imgUrl
  PopularEventTile({this.address, this.date, this.imgeAssetPath, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    desc,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/calender.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        date,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/location.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.network(
                imgeAssetPath,
                errorBuilder: (context, error, stackTrace) {
                  print(stackTrace);
                  return SizedBox();
                },
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }
}
