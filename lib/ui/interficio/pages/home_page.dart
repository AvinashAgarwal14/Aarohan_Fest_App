import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aavishkarapp/util/inner_drawer.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState(user);
}

GoogleMapController mapController;

String api_url = "jd.nitdgplug.org";

bool header = false;

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Map<String, dynamic> user;
  _HomePageState(this.user);

  var currentLocation = LocationData;
  var location = new Location();
  var lat, long, accuracy;

  Map<String, dynamic> levelData = {}; //stores data of current level of user
  Map<String, dynamic> clueData = {};
  Map<String, dynamic> unlockedClueData = {};

  List<dynamic> leaderboard; //stores the current leaderboard

  final _answerFieldController =
      TextEditingController(); //to retrieve textfield value

  final _fieldFocusNode = new FocusNode(); //to deselect answer textfield

  bool _isLoading = false;

  void getLocation() async {
    bool perm = await location.hasPermission();
    print(perm);
    LocationData currentLocation = await location.getLocation();
    location.changeSettings(accuracy: LocationAccuracy.HIGH);
    setState(
      () {
        location.onLocationChanged().listen(
          (LocationData currentLocation) {
            setState(
              () {
                lat = currentLocation.latitude;
                long = currentLocation.longitude;
                accuracy = currentLocation.accuracy;
              },
            );
          },
        );
      },
    );
  }

//this function retrieves the data of the current level of the user
  Future getLevelData() async {
    setState(() {
      _isLoading = true;
    });

    http.Response response = await http.get(
        Uri.encodeFull("https://$api_url/api/getlevel/"),
        headers: {"Authorization": "Token ${user["token"]}"});
    levelData = json.decode(response.body);
    print(levelData);

    if (levelData["level"] == "ALLDONE")
      clueData = {"data": "finished"};
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("currentLevel", "${levelData["level_no"]}");
      http.Response clues = await http.get(
          Uri.encodeFull(
              "https://$api_url/api/getlevelclues/?level_no=${levelData["level_no"]}"),
          headers: {"Authorization": "Token ${user["token"]}"});
      clueData = json.decode(clues.body);
    }

    print(clueData);
    setState(() {
      _isLoading = false;
    });
  }

  Future getUnclockedClues() async {
    setState(() {
      _isLoading = true;
    });
    print("start");
    print(levelData["level_no"]);
    if (levelData["level_no"] == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      levelData["level_no"] = leaderboard[0]["current_level"];

      print(levelData["level_no"]);
    }
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://$api_url/api/getclues/?level_no=${levelData["level_no"]}"),
        headers: {
          "Authorization": "Token ${user["token"]}",
          "Content-type": "application/json"
        });
    print("done");

    unlockedClueData = json.decode(response.body);
    print(" fdbdfbetne $unlockedClueData");
    setState(() {
      _isLoading = false;
    });
  }

//this function retrieves the current leaderboard
  Future getScoreboard() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.get(
        Uri.encodeFull("https://$api_url/api/scoreboard/"),
        headers: {"Authorization": "Token ${user["token"]}"});
    leaderboard = json.decode(response.body);
    setState(() {
      _isLoading = false;
    });
  }

  Future unlockClue(clueNo) async {
    setState(() {
      _isLoading = true;
    });

    http.Response response = await http.get(
        Uri.encodeFull(
            "https://$api_url/api/unlockclue/?level_no=${levelData["level_no"]}&clue_no=$clueNo"),
        headers: {"Authorization": "Token ${user["token"]}"}).then((onValue) {
      getLevelData();
    });

    print(json.decode(response.body));

    setState(() {
      _isLoading = false;
    });
  }

//this function submits the current location of the user
  Future submitLocation() async {
    setState(() {
      _isLoading = true;
    });
    if (accuracy > 25) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("location not accurate enough. please try again"),
        duration: Duration(seconds: 1),
      ));
    } else {
      http.Response response = await http.post(
        Uri.encodeFull("https://$api_url/api/submit/location/"),
        headers: {
          "Authorization": "Token ${user["token"]}",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "lat": lat,
          "long": long,
          "level_no": levelData["level_no"],
        }),
      );
      var data = json.decode(response.body);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text(data["success"] == true ? "correct location" : "try again"),
        duration: Duration(seconds: 1),
      ));
    }
    setState(() {
      getLevelData().then((onValue) {
        getUnclockedClues();
      });
    });
  }

  @override
  void dispose() {
    _answerFieldController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    getLocation();
    getLevelData().then((val) {
      getScoreboard().then((onValue) {
        getUnclockedClues();
      });
    });
  }

  final LabeledGlobalKey<InnerDrawerState> _innerDrawerKey =
      LabeledGlobalKey<InnerDrawerState>("label");

  void _toggle() {
    _innerDrawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        direction: InnerDrawerDirection.start);
  }

  bool _isUp =
      true; //to maintain state of the animation of leaderboard, instruction sheet
  bool _isOpen = false; //to maintain animation of question, answer box

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //for bottomsnackbar

  Widget drawerClues() {
    return _isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Material(
            color: Colors.white.withOpacity(0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "CURRENT CLUES",
                    style: GoogleFonts.uncialAntiqua(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                clueData["data"] == "finished"
                    ? Container()
                    : Container(
                        height: MediaQuery.of(context).size.height / 3,
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: clueData["data"].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF191970),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 10.0,
                                        spreadRadius: 1.0),
                                    //   BoxShadow(
                                    //       color: Colors.white,
                                    //       offset: Offset(-2.0, -2.0),
                                    //       blurRadius: 10.0,
                                    //       spreadRadius: 1.0),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                leading: IconButton(
                                  color: clueData["data"][index][2] != null
                                      ? Colors.green
                                      : Color(0xFFa94064),
                                  onPressed: clueData["data"][index][2] == null
                                      ? () {
                                          showDialog(
                                            context: context,
                                            child: Dialog(
                                              backgroundColor:
                                                  Colors.white.withOpacity(0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFa94064),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                padding: EdgeInsets.all(15),
                                                height: 150,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      "Are you sure you want to unlock this clue?",
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    ButtonBar(
                                                      children: <Widget>[
                                                        OutlineButton(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFa94064), //Color of the border
                                                            style: BorderStyle
                                                                .solid, //Style of the border
                                                            width:
                                                                1, //width of the border
                                                          ),
                                                          child: Text(
                                                            "UNLOCK",
                                                            style: GoogleFonts
                                                                .ubuntu(),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              unlockClue(clueData[
                                                                      "data"]
                                                                  [index][0]);
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(true);
                                                            });
                                                          },
                                                        ),
                                                        OutlineButton(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFa94064), //Color of the border
                                                            style: BorderStyle
                                                                .solid, //Style of the border
                                                            width:
                                                                1, //width of the border
                                                          ),
                                                          child: Text(
                                                            "GO BACK",
                                                            style: GoogleFonts
                                                                .ubuntu(),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop(true);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      : () {},
                                  icon: Icon(clueData["data"][index][2] != null
                                      ? Icons.lock_open
                                      : Icons.lock),
                                ),
                                title: clueData["data"][index][2] != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${clueData["data"][index][1]} \n\n ",
                                            style: GoogleFonts.ubuntu(
                                                color: Color(0xFFa94064)),
                                          ),
                                          Text(
                                            "${clueData["data"][index][2]}",
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        clueData["data"][index][1],
                                        style: GoogleFonts.ubuntu(
                                          color: Color(0xFFa94064),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "UNLOCKED CLUES",
                    style: GoogleFonts.uncialAntiqua(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: unlockedClueData["data"].length,
                      itemBuilder: (BuildContext context, int index) {
                        if (unlockedClueData["data"][index][2] != null)
                          return Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF191970),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 1.0),
                                  // BoxShadow(
                                  //     color: Colors.white,
                                  //     offset: Offset(-2.0, -2.0),
                                  //     blurRadius: 10.0,
                                  //     spreadRadius: 1.0),
                                ],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              // leading: IconButton(
                              //   color: Color(0xFFa94064),
                              //   onPressed: () {},
                              //   icon: Icon(Icons.vpn_key),
                              // ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${unlockedClueData["data"][index][1]} \n\n ",
                                    style: GoogleFonts.ubuntu(
                                        color: Color(0xFFa94064)),
                                  ),
                                  Text(
                                    "${unlockedClueData["data"][index][2]}",
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        else
                          return Container();
                      }),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

//animation using animatedpositioned. mean position toggle values
    double bottom = _isUp ? 65.0 : (deviceSize.height / 2);
    double top = _isUp
        ? (_isOpen ? deviceSize.height / 4 : (deviceSize.height * 3 / 4))
        : bottom;
    double top2 =
        _isUp ? (deviceSize.height - 80) : ((deviceSize.height) / 2) + 10;
    var bottom3 = _isUp ? deviceSize.height : ((deviceSize.height) / 2) + 10;
    var bottom4 = _isUp ? 10.0 : deviceSize.height - 80;
    var right4 = 20.0;

    return SafeArea(
      child: InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true, // default false
        swipe: true, // default true
        colorTransition: Color(0xFF87ceeb), // default Color.black54

        // DEPRECATED: use offset
        leftOffset: 0.3, // Will be removed in 0.6.0 version
        // rightOffset: 0.6, // Will be removed in 0.6.0 version

        //When setting the vertical offset, be sure to use only top or bottom
        offset: IDOffset.only(bottom: 0.2, right: 0.5, left: 0.5),

        // DEPRECATED:  use scale
        leftScale: 0.9, // Will be removed in 0.6.0 version
        rightScale: 0.9, // Will be removed in 0.6.0 version

        scale: IDOffset.horizontal(0.8), // set the offset in both directions

        proportionalChildArea: true, // default true
        borderRadius: 50, // default 0
        leftAnimationType: InnerDrawerAnimation.static, // default static
        rightAnimationType: InnerDrawerAnimation.quadratic,

        // Color(0xFFa94064).withOpacity(0.8),
        // Color(0xFF191970).withOpacity(0.7)
        backgroundColor: Color(0xFF191970).withOpacity(0.8),

        onDragUpdate: (double val, InnerDrawerDirection direction) {
          print(val);
          print(direction == InnerDrawerDirection.start);
        },
        innerDrawerCallback: (a) {
          _animationController.value == 0
              ? _animationController.forward()
              : _animationController.reverse();
        },
        leftChild: Container(
          color: Colors.white.withOpacity(0),
          child: _isLoading ? Container() : drawerClues(),
        ),

        scaffold: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: true,
          // drawer: AppBar(automaticallyImplyLeading: false,),
          body: Stack(
            children: <Widget>[
              GameMap(),
              Padding(
                padding: EdgeInsets.all(15),
                child: IconButton(
                  iconSize: 35,
                  onPressed: () {
                    _toggle();
                    _animationController.value == 1
                        ? _animationController.forward()
                        : _animationController.reverse();
                  },
                  icon: AnimatedIcon(
                      color: Color(0xFFa94064),
                      progress: _animationController,
                      icon: AnimatedIcons.menu_close),
                ),
              ), //google map as main background of the app
              AnimatedPositioned(
                //top instructions panel
                bottom: bottom3,
                right: 0.0,
                left: 0.0,
                top: -15.0,
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.easeOutQuart,
                    opacity: _isUp ? 0.5 : 0.8,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset.zero,
                              blurRadius: 10,
                              spreadRadius: 5),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 0.8, 1.0],
                          colors: [
                            Colors.grey[900],
                            Colors.grey[600],
                            Colors.grey
                          ],
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "INSTRUCTIONS",
                          style: GoogleFonts.uncialAntiqua(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                //level box displayed on home page
                bottom: bottom,
                right: 10.0,
                left: 10.0,
                top: top,
                duration: Duration(milliseconds: 900),
                curve: Curves.bounceOut,
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.easeOutQuart,
                    opacity: _isUp ? (_isOpen ? 1 : 0.8) : 0.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isOpen = !_isOpen;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset.zero,
                                blurRadius: 10,
                                spreadRadius: 5),
                          ],
                          color: Color(0xFF191970),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              child: _isLoading
                                  ? Container(
                                      padding: EdgeInsets.only(right: 20),
                                      child: CircularProgressIndicator())
                                  : levelData["level"] == "ALLDONE"
                                      ? Text("All done!")
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              "${levelData["title"]}  🚩",
                                              style: GoogleFonts.uncialAntiqua(
                                                color: _isOpen
                                                    ? Color(0xFF0059B3)
                                                    : Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "level number: ${levelData["level_no"]}",
                                              style: TextStyle(
                                                color: _isOpen
                                                    ? Color(0xFFa94064)
                                                    : Color(0xFFa94064),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading || levelData["title"] == null
                  ? Container(
                      // padding: EdgeInsets.only(right: 20),
                      // child: CircularProgressIndicator(),
                      )
                  : AnimatedPositioned(
                      //question along with textfield for answer and submit button
                      top: _isOpen && _isUp
                          ? deviceSize.height / 2.5
                          : deviceSize.height + 5.0,
                      bottom: _isOpen && _isUp ? 75.0 : -5.0,
                      left: 20.0,
                      right: 20.0,
                      duration: Duration(milliseconds: 900),
                      curve: Curves.easeOutQuart,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: Container(
                          child: Center(
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFa94064),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      levelData["ques"],
                                      style: GoogleFonts.mysteryQuest(
                                          color: _isOpen
                                              ? Colors.white
                                              : Colors.white,
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  ListTile(
                                    // title: levelData["map_hint"]
                                    //     ?
                                    title: Container(
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "YOUR CURRENT LOCATION",
                                              style: GoogleFonts.uncialAntiqua(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ListTile(
                                              leading: Icon(Icons
                                                  .subdirectory_arrow_left),
                                              title: Text("LATITUDE: $lat",
                                                  style: GoogleFonts
                                                      .josefinSans()),
                                            ),
                                            ListTile(
                                              leading: Icon(Icons
                                                  .subdirectory_arrow_right),
                                              title: Text(
                                                "LONGITUDE: $long",
                                                style:
                                                    GoogleFonts.josefinSans(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlineButton(
                                        borderSide: BorderSide(
                                          color: Color(
                                              0xFFa94064), //Color of the border
                                          style: BorderStyle
                                              .solid, //Style of the border
                                          width: 1, //width of the border
                                        ),
                                        color: Color(0xFFa94064),
                                        child: Text(
                                          "GET CLUES",
                                          style: GoogleFonts.uncialAntiqua(),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _toggle();
                                          });
                                        },
                                      ),
                                      OutlineButton(
                                        borderSide: BorderSide(
                                          color: Color(
                                              0xFFa94064), //Color of the border
                                          style: BorderStyle
                                              .solid, //Style of the border
                                          width: 1, //width of the border
                                        ),
                                        child: Text(
                                          "SUBMIT",
                                          style: GoogleFonts.uncialAntiqua(),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            submitLocation();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              AnimatedPositioned(
                //leaderboard generated dynamically using listview.builder
                bottom: -15.0,
                right: 0.0,
                left: 0.0,
                top: top2,
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.easeOutQuart,
                    opacity: _isUp ? 0.8 : 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print("leader");
                          _isUp = !_isUp;
                          getScoreboard();
                        });
                      },
                      onVerticalDragStart: (context) {
                        setState(() {
                          print("leader");
                          _isUp = !_isUp;
                          getScoreboard();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset.zero,
                                blurRadius: 10,
                                spreadRadius: 5),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.3, 1.0],
                            // Color(0xFFa94064).withOpacity(0.8),
                            // Color(0xFF191970).withOpacity(0.7)
                            // Color(0xFF0091FF), Color(0xFF0059FF)
                            colors: [
                              Color(0xFF191970),
                              Color(0xFFa94064),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Center(
                          child: ListView.builder(
                            itemCount: leaderboard == null
                                ? 0
                                : leaderboard.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(width: 40),
                                          Text(
                                            "name",
                                            style: TextStyle(
                                                fontSize: 31,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFFFFE000)),
                                          )
                                        ]),
                                    Text(
                                      "score",
                                      style: TextStyle(
                                          fontSize: 31,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFFFFE000)),
                                    )
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "$index",
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          leaderboard[index - 1]["name"],
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${leaderboard[index - 1]["current_level"]}",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                //leaderboard icon that triggers animation
                bottom: deviceSize.height - top2 - 25,
                left: 20,
                top: top2 - 35,
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                child: GestureDetector(
                  onVerticalDragStart: (context) {
                    setState(() {
                      _isUp = !_isUp;
                      getScoreboard();
                    });
                  },
                  child: Image.asset("assets/leaderboard.png"),
                ),
              ),
              AnimatedPositioned(
                //info icon that triggers animation
                bottom: bottom4,
                right: right4,
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print("he");
                      _isUp = !_isUp;
                      getScoreboard();
                    });
                  },
                  // onVerticalDragStart: (context) {
                  //   setState(() {
                  //     print("he");
                  //     _isUp = !_isUp;
                  //     getScoreboard();
                  //   });
                  // },
                  child: Icon(
                    Icons.info,
                    size: 70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.554079, 87.278687),
        zoom: 13,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
