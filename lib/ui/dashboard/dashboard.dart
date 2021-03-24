import 'dart:async';
import 'package:arhn_app_2021/model/date_model.dart';
import 'package:arhn_app_2021/model/event.dart';
import 'package:arhn_app_2021/model/event_type_model.dart';
import 'package:arhn_app_2021/util/event_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show SystemChrome;
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../util/drawer2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arhn_app_2021/data/data.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

PageController controller;
ScrollController _scontroller;
final textFieldController = TextEditingController();
bool _showDate = true;
bool _showCategory = true;
bool _showSearchBox = false;
FocusNode myFocusNode;
bool _showBottomSlide = false;

EventResponse res;
List<EventItem> events;
List<EventItem> showEvents;

Color background = const Color(0xff121212);
Color cardColor = const Color(0xff343536);

List<String> tags = <String>[
  'Logic',
  'Strategy',
  'Mystery',
  'Innovation',
  'Treasure Hunt',
  'Coding',
  'Sports',
  'Robotics',
  'Workshops',
  'Buisness'
];

var _selectedTag = 'All';
List<Widget> cardChildren;

class _DashboardState extends State<Dashboard> {
  List<DateModel> dates = new List<DateModel>();
  List<EventTypeModel> eventsType = new List();

  // List<EventsModel> events = new List<EventsModel>();
  String todayDateIs = "8";

  bool darkThemeEnabled = false;
  FirebaseUser currentUser;
  int isEurekoinAlreadyRegistered;
  String barcodeString;
  final loginKey = '123*aavishkar';
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  int click = 0, gclick = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
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

    myFocusNode = FocusNode();

    _scontroller = ScrollController();
    _scontroller.addListener(_scrollListener);

    getJSON().then((value) {
      print(json.decode(value));
      res = EventResponse.fromJSON(json.decode(value));
      setState(() {
        events = res.events;
        showEvents = res.events;
      });
    });

    dates = getDates();
    eventsType = getEventTypes();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller = PageController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: background,
    ));
    getUser();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _showBottomSlide = !visible;
        });
      },
    );
  }

  _scrollListener() {
    setState(() {
      _showDate = _scontroller.offset < 50;
      _showCategory = _scontroller.offset < 200;
    });
  }

  Future getJSON() {
    return DefaultAssetBundle.of(context)
        .loadString('assets/aarohan_events.json');
  }

  int selectedIndexC = 0;
  var w = 50.0;
  var myCurve = Curves.easeInCirc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("${ModalRoute.of(context).settings.name}");
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer("/ui/dashboard"),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
              child: Column(
                children: [
                  Container(
                    height: 60.0,
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 400),
                          opacity: !_showSearchBox ? 0 : 1,
                          child: AnimatedContainer(
                            alignment: Alignment.centerRight,
                            duration: Duration(milliseconds: 400),
                            height: 60,
                            width: !_showSearchBox
                                ? 0
                                : MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Focus(
                                        onFocusChange: (Focus) {
                                          setState(() {
                                            _showBottomSlide = !Focus;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    112, 113, 119, 0.25),
                                                offset: Offset(-1, -1),
                                                blurRadius: 8,
                                              ),
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    13, 13, 15, 0.3),
                                                offset: Offset(2, 2),
                                                blurRadius: 12,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFF2C3035),
                                          ),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                BorderRadius.circular(4),
                                              ),
                                              depth: -1,
                                              lightSource: LightSource.topLeft,
                                              color: Color(0xFF2C3035),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(3),
                                              child: TextField(
                                                onChanged:
                                                    (String value) async {
                                                  setState(() {
                                                    showEvents = events
                                                        .where((event) =>
                                                            event != null &&
                                                            event.title
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(value
                                                                    .toLowerCase()))
                                                        .toList();
                                                  });
                                                },
                                                controller: textFieldController,
                                                focusNode: myFocusNode,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  focusColor: Color(0xff03A062),
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 10, right: 10),
                                      child: NeumorphicButton(
                                        onPressed: () {
                                          setState(() {
                                            _showSearchBox = !_showSearchBox;
                                            myFocusNode.unfocus();
                                            showEvents = res.events;
                                            textFieldController.clear();
                                          });
                                        },
                                        padding: EdgeInsets.all(0),
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.concave,
                                          boxShape: NeumorphicBoxShape.circle(),
                                          depth: 7.5,
                                          intensity: 1.0,
                                          lightSource: LightSource.topLeft,
                                          shadowLightColor:
                                              Colors.grey[700].withOpacity(0.6),
                                          shadowDarkColor: Colors.black,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF63d471)
                                                  .withOpacity(0.5),
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
                                              Icons.cancel,
                                              color: Colors.white,
                                              // size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // FloatingActionButton(
                                    //   elevation: 0,
                                    //   foregroundColor:
                                    //       Colors.white, //(0xFF6B872B),
                                    //   backgroundColor: Colors.transparent,
                                    //   onPressed: () {
                                    //     setState(() {
                                    //       _showSearchBox = !_showSearchBox;
                                    //       myFocusNode.unfocus();
                                    //       showEvents = res.events;
                                    //       textFieldController.clear();
                                    //     });
                                    //   },
                                    //   child: Icon(Icons.cancel),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          // curve: ,
                          alignment: Alignment.centerLeft,
                          duration: Duration(milliseconds: 400),
                          height: 60,
                          width: _showSearchBox
                              ? 0
                              : MediaQuery.of(context).size.width,
                          //width: 50,
                          // color: background,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: NeumorphicButton(
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
                                      shadowLightColor:
                                          Colors.grey[700].withOpacity(0.6),
                                      shadowDarkColor: Colors.black,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFF63d471)
                                              .withOpacity(0.5),
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
                                ),
                              ), //Flexible

                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 60,
                                    // color: background,
                                    child: Text(
                                      "Aarohan",
                                      style: GoogleFonts.josefinSans(
                                          fontSize: 30,
                                          color: Colors.white //(0xFF6B872B),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              // Flexible(
                              //     flex: 2,
                              //     fit: FlexFit.tight,
                              //     child: SizedBox()),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      setState(() {
                                        _showSearchBox = !_showSearchBox;
                                        _showBottomSlide = true;
                                        // myFocusNode.
                                      });
                                    },
                                    padding: EdgeInsets.all(0),
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.circle(),
                                      depth: 7.5,
                                      intensity: 1.0,
                                      lightSource: LightSource.topLeft,
                                      shadowLightColor:
                                          Colors.grey[700].withOpacity(0.6),
                                      shadowDarkColor: Colors.black,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFF63d471)
                                              .withOpacity(0.5),
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
                                          Icons.search,
                                          color: Colors.white,
                                          // size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Flexible
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          curve: myCurve,
                          height: _showDate && !_showSearchBox ? 70 : 0,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                            child: Row(
                              children: dates
                                  .map(
                                    (date) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          todayDateIs = date.date;
                                          showEvents = events
                                              .where((event) =>
                                                  event != null &&
                                                  int.parse(event.date
                                                          .substring(0, 2)) ==
                                                      int.parse(date.date))
                                              .toList();
                                        });
                                      },
                                      child: DateTile(
                                        weekDay: date.weekDay,
                                        date: date.date,
                                        isSelected: todayDateIs == date.date,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          height: _showDate && !_showSearchBox ? 56 : 0,
                          duration: Duration(milliseconds: 200),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  alignment: Alignment.centerLeft,
                                  // color: background,
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          // curve: myCurve,
                          height: _showDate && !_showSearchBox ? 70 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            //height: 70,
                            child: ListView.builder(
                                itemCount: eventsType.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndexC = index;
                                      });
                                    },
                                    child: EventTile(
                                        imgAssetPath:
                                            eventsType[index].imgAssetPath,
                                        eventType: eventsType[index].eventType,
                                        isSelected: index == selectedIndexC),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: _showDate && !_showSearchBox ? 16 : 0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: showEvents != null
                          ? ListView.builder(
                              controller: _scontroller,
                              itemCount: showEvents.length,
                              itemBuilder: (context, index) {
                                return events[index] != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return EventDetails(
                                                item: showEvents[index]);
                                          }));
                                        },
                                        child: Neumorphic(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 9.0, horizontal: 15.0),
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                              BorderRadius.circular(12.0),
                                            ),
                                            depth: 8.0,
                                            intensity: 1.0,
                                            lightSource: LightSource.top,
                                            shadowLightColor: Colors.grey[700]
                                                .withOpacity(0.55),
                                            shadowDarkColor: Colors.black,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF292D32),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            height: 100.0,
                                            // width: MediaQuery.of(context).size.width * 0.7,
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Neumorphic(
                                                  style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    boxShape: NeumorphicBoxShape
                                                        .roundRect(
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                    ),
                                                    depth: 8.0,
                                                    intensity: 0.7,
                                                    lightSource:
                                                        LightSource.top,
                                                    shadowLightColor: Colors
                                                        .grey[700]
                                                        .withOpacity(0.7),
                                                    shadowDarkColor: Colors
                                                        .black
                                                        .withOpacity(0.9),
                                                  ),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.28,
                                                    child: CachedNetworkImage(
                                                      height: 100,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        print(
                                                            "Could not load content");
                                                        return Image.asset(
                                                            "images/imageplaceholder.png");
                                                      },
                                                      placeholder: (context,
                                                              url) =>
                                                          Image.asset(
                                                              "images/imageplaceholder.png"),
                                                      imageUrl:
                                                          showEvents[index]
                                                              .imageUrl,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                      // border: Border.all(
                                                      //   style:
                                                      //       BorderStyle.solid,
                                                      //   width: 1.5,
                                                      //   color: Color(0xFF63d471)
                                                      //       .withOpacity(0.5),
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16),
                                                    // width:
                                                    //     MediaQuery.of(context)
                                                    //             .size
                                                    //             .width -
                                                    //         100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                      border: Border.all(
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.5,
                                                        color: Colors.grey[700]
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          showEvents[index]
                                                              .title,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                              showEvents[index]
                                                                  .date,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
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
                                                            Hero(
                                                              tag:
                                                                  "${showEvents[index].title}${showEvents[index].title}",
                                                              child: Text(
                                                                showEvents[
                                                                        index]
                                                                    .location,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox();
                              },
                            )
                          : SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            _showSearchBox && _showBottomSlide ? new BottomSlide() : SizedBox()
          ],
        ),
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
    var email = currentUser.providerData[1].email;
    var bytes = utf8.encode("$email" + "$loginKey");
    var encoded = sha1.convert(bytes);

    String apiUrl = "https://eurekoin.nitdgplug.org/api/exists/?token=$encoded";
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
        "https://eurekoin.nitdgplug.org/api/coupon/?token=$encoded&code=$coupon";
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
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Neumorphic(
          margin: EdgeInsets.symmetric(horizontal: 10),
          style: NeumorphicStyle(
            color: Color(0xFF292D32),
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(12.0),
            ),
            depth: 5,
            intensity: 1,
            lightSource: LightSource.topLeft,
            shadowLightColor: Colors.grey[700].withOpacity(0.5),
            shadowDarkColor: Colors.black,
          ),
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.18,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFF78e08f)
                  : Color(0xFF292D32), //Color(0xff29404E),
              border: Border.all(
                color: isSelected
                    ? Color(0xFF03A062).withOpacity(0.5)
                    : Colors.grey[700].withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              // boxShadow: (isSelected && _showDate)
              //     ? [
              //         BoxShadow(
              //           color: Color(0xff03A062),
              //           spreadRadius: 4,
              //           blurRadius: 10,
              //         ),
              //         BoxShadow(
              //           color: Color(0xff03A062),
              //           spreadRadius: -4,
              //           blurRadius: 5,
              //         ),
              //       ]
              //     : [],
            ),
            child: Center(
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
            ),
          ),
        ));
  }
}

class BottomSlide extends StatefulWidget {
  @override
  _BottomSlideState createState() => _BottomSlideState();
}

List<EventItem> bottomSlideList = events;

class _BottomSlideState extends State<BottomSlide> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> choiceChips = tags.map<Widget>((String name) {
      Color chipColor;
      chipColor = Color(0xFF78e08f);
      return ChoiceChip(
        key: new ValueKey<String>(name),
        backgroundColor: chipColor,
        label: new Text(name,
            style: TextStyle(
              color: _selectedTag == name ? Colors.white : Colors.black,
            )),
        selected: _selectedTag == name,
        selectedColor: chipColor.withOpacity(0.3),
        onSelected: (bool value) {
          setState(() {
            _selectedTag = value ? name : _selectedTag;
            bottomSlideList = events
                .where((element) =>
                    element != null &&
                    element.tag
                        .toLowerCase()
                        .contains(_selectedTag.toLowerCase()))
                .toList();
          });
          print(bottomSlideList);
          print(_selectedTag);
        },
      );
    }).toList();

    cardChildren = <Widget>[
      new Wrap(
          children: choiceChips.map((Widget chip) {
        return new Padding(
          padding: const EdgeInsets.all(2.0),
          child: chip,
        );
      }).toList())
    ];

    return SlidingUpPanel(
      // color: Colors.black,
      minHeight: 200.0,
      maxHeight: MediaQuery.of(context).size.height * 0.80,
      panel: Container(
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
        child: Column(
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
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                )
              ],
            ),
            SizedBox(height: 13.0),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Divider(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey
                  : Color(0xFF505194),
            ),
            Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: cardChildren,
              ),
            ),
            SizedBox(height: 13.0),
            Container(
              child: Expanded(
                child: events != null
                    ? ListView.builder(
                        controller: _scontroller,
                        itemCount: bottomSlideList.length,
                        itemBuilder: (context, index) {
                          return bottomSlideList[index] != null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return EventDetails(
                                          item: bottomSlideList[index]);
                                    }));
                                  },
                                  child: PopularEventTile(
                                    desc: bottomSlideList[index].title,
                                    imgeAssetPath:
                                        bottomSlideList[index].imageUrl,
                                    date: bottomSlideList[index].date,
                                    address: bottomSlideList[index].location,
                                  ),
                                )
                              : SizedBox();
                        },
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  bool isSelected;
  EventTile({this.imgAssetPath, this.eventType, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Neumorphic(
        margin: EdgeInsets.all(10),
        style: NeumorphicStyle(
          color: Color(0xFF292D32),
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12.0),
          ),
          depth: 3,
          intensity: 1,
          lightSource: LightSource.topLeft,
          shadowLightColor: Colors.grey[700].withOpacity(0.5),
          shadowDarkColor: Colors.black,
        ),
        child: Container(
          height: 60,
          width: 170,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFF78e08f)
                : Color(0xFF292D32), //Color(0xff29404E),
            border: Border.all(
              color: isSelected
                  ? Color(0xFF03A062).withOpacity(0.5)
                  : Colors.grey[700].withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            // boxShadow: (isSelected && _showDate)
            //     ? [
            //         BoxShadow(
            //           color: Color(0xff03A062),
            //           spreadRadius: 4,
            //           blurRadius: 10,
            //         ),
            //         BoxShadow(
            //           color: Color(0xff03A062),
            //           spreadRadius: -4,
            //           blurRadius: 5,
            //         ),
            //       ]
            //     : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imgAssetPath,
                color: isSelected ? Colors.black : Colors.white,
                height: 27,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                eventType,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                ),
              )
            ],
          ),
          // ),
        ),
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
    return Neumorphic(
      margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 15.0),
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12.0),
        ),
        depth: 8.0,
        intensity: 1.0,
        lightSource: LightSource.top,
        shadowLightColor: Colors.grey[700].withOpacity(0.55),
        shadowDarkColor: Colors.black,
      ),
      child: Container(
        height: 100,
        // margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          //#303236
          color: cardColor,

          // borderRadius: BorderRadius.only(
          //  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          //border: Border.all(color: Color(0xff03A062), width: 2)
        ),
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
                        Hero(
                          tag: "${desc}${address}",
                          child: Text(
                            address,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              tag: imgeAssetPath,
              child: CachedNetworkImage(
                height: 100,
                width: 120,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  print("Could not load content");
                  return Image.asset("images/imageplaceholder.png");
                },
                placeholder: (context, url) =>
                    Image.asset("images/imageplaceholder.png"),
                imageUrl: imgeAssetPath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
