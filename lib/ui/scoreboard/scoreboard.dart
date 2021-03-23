import 'dart:async';
import 'dart:convert';
import 'package:decoding_text_effect/decoding_text_effect.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  User(this.rank, this.username, this.email, this.score);
  int rank;
  String username;
  String email;
  int score;
  set setRank(num value) => rank = value;
  set setUsername(String value) => username = value;
  set setEmail(String value) => email = value;
  set setScore(num value) => score = value;
}

List<dynamic> ctfUsers = List();
List<dynamic> digitalfortressUsers = List();
List<dynamic> freemexUsers = List();
//List<dynamic> freeplUsers = List();
//List<dynamic> interficioUsers = List();
List<dynamic> othUsers = List();
//List<dynamic> roadrangerUsers = List();

List<User> _uSeR = List();
List<DropdownMenuItem<String>> eventList = [
  DropdownMenuItem(
    child: Text(
      "Capture The Flag",
      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
    ),
    value: "CTF",
  ),
  DropdownMenuItem(
    child:
        Text("Digital Fortress", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
    value: "Digitalfortress",
  ),
  DropdownMenuItem(
    child: Text("Freemex", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
    value: "Freemex",
  ),
//  DropdownMenuItem(
//    child: Text("Freepl", style: TextStyle(fontWeight: FontWeight.bold)),
//    value: "Freepl",
//  ),
//  DropdownMenuItem(
//    child: Text("Interficio", style: TextStyle(fontWeight: FontWeight.bold)),
//    value: "Interficio",
//  ),
  DropdownMenuItem(
    child: Text("Online Treasure Hunt",
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
    value: "OTH",
  ),
//  DropdownMenuItem(
//    child: Text("Roadranger", style: TextStyle(fontWeight: FontWeight.bold)),
//    value: "Roadranger",
//  ),
];

class UserDataSource extends DataTableSource {
  void _sort<T>(Comparable<T> getField(User d), bool ascending) {
    _uSeR.sort((User a, User b) {
      if (!ascending) {
        final User c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _uSeR.length) return null;
    final User temp = _uSeR[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${temp.rank}')),
      DataCell(Text('${temp.username}')),
      DataCell(Text('${temp.score}')),
      DataCell(Text('${temp.email}')),
    ]);
  }

  @override
  int get rowCount => _uSeR.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class Scoreboard extends StatefulWidget {
  // static const String routeName = '/material/data-table';
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  String Selected;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true,
      dataRecieved = false,
      firsttimeDatafetched = false;
  bool comingsoon,
      ctf,
      digitalfortress,
      freemex,
      //   freepl,
      //   interficio,
      oth
      //   roadranger
      ;
  UserDataSource _userDataSource = UserDataSource();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForScoreboard;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Selected = null;
    _databaseReferenceForScoreboard = _database.reference().child("Scoreboard");
    _databaseReferenceForScoreboard.onChildAdded.listen(_onEntryAdded);
    _databaseReferenceForScoreboard.onChildChanged.listen(_onEntryUpdated);
    //getData();
    //Selected="None";
    createUserList("none");
    print("In initstate");
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //       statusBarColor: Color(0xFF6B872B),
    //       systemNavigationBarIconBrightness: Brightness.dark));
  }

  void _onEntryAdded(Event event) {
    setState(() {
      comingsoon = event.snapshot.value['comingsoon'];
      ctf = event.snapshot.value['ctf'];
      digitalfortress = event.snapshot.value['digitalfortress'];
      freemex = event.snapshot.value['freemex'];
      //   freepl = event.snapshot.value['freepl'];
      //   interficio = event.snapshot.value['interficio'];
      oth = event.snapshot.value['oth'];
      //   roadranger = event.snapshot.value['roadranger'];
    });
  }

  void _onEntryUpdated(Event event) {
    setState(() {
      print(event.snapshot.value);
      comingsoon = event.snapshot.value['comingsoon'];
      ctf = event.snapshot.value['ctf'];
      digitalfortress = event.snapshot.value['digitalfortress'];
      freemex = event.snapshot.value['freemex'];
      //    freepl = event.snapshot.value['freepl'];
      //    interficio = event.snapshot.value['interficio'];
      oth = event.snapshot.value['oth'];
      //   roadranger = event.snapshot.value['roadranger'];
    });
  }

  void _sort<T>(
      Comparable<T> getField(User d), int columnIndex, bool ascending) {
    _userDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (comingsoon != null &&
            digitalfortress != null &&
            freemex != null &&
            //    freepl != null &&
            oth != null &&
            ctf != null
        // && roadranger != null
        // && interficio != null
        ) {
      print("comming soon: $comingsoon");
      if (comingsoon == false) {
        if (!firsttimeDatafetched) {
          getData();
          firsttimeDatafetched = true;
        }
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

            // appBar: AppBar(
            //   title: const Text('Live Scoreboard'),
            //   elevation: 10.0,
            // ),
            body: Container(
              //height: MediaQuery.of(context).size.height,
              //width: MediaQuery.of(context).size.width/2,
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
              child: RefreshIndicator(
                displacement: 100.0,
                backgroundColor: Colors.white,
                key: _refreshIndicatorKey,
                onRefresh: getDataOnRefresh,
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        padding: const EdgeInsets.all(10.0),
                        children: <Widget>[
                          Row(
                            children: [
                              backButton(),
                              SizedBox(
                                width: 20,
                              ),
                              DecodingTextEffect(
                                "Scoreboard",
                                decodeEffect: DecodeEffect.fromStart,
                                textStyle: GoogleFonts.josefinSans(
                                    fontSize: 30,
                                    color: Colors.white //(0xFF6B872B),
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0, bottom: 20),
                            alignment: Alignment.topCenter,
                            child: DropdownButton(
                              dropdownColor: Colors.black,
                              value: Selected,
                              iconSize: 13.0,
                              hint: Text("Select Event",
                                  style: TextStyle(color: Colors.white)),
                              items: eventList,
                              elevation: 20,
                              onChanged: ((value) {
                                setState(() {
                                  Selected = value;
                                  dataRecieved = false;
                                });
                                createUserList(value);
                              }),
                            ),
                          ),
                          ((Selected != null)
                              ? getNu(
                                  Stack(
                                    alignment: AlignmentDirectional.topCenter,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.8,
                                        child: PaginatedDataTable(
                                            header: Center(
                                                child: Text(
                                              'Score Card',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                            rowsPerPage: _rowsPerPage,
                                            onRowsPerPageChanged: (int value) {
                                              setState(() {
                                                _rowsPerPage = value;
                                              });
                                            },
                                            sortColumnIndex: _sortColumnIndex,
                                            sortAscending: _sortAscending,
                                            columns: <DataColumn>[
                                              DataColumn(
                                                  label: const Text('Rank',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  numeric: true,
                                                  onSort: (int columnIndex,
                                                          bool ascending) =>
                                                      _sort<num>(
                                                          (User d) => d.rank,
                                                          columnIndex,
                                                          ascending)),
                                              DataColumn(
                                                label: const Text('User',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                // tooltip: d.email,
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                  label: const Text('Score',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  numeric: true,
                                                  onSort: (int columnIndex,
                                                          bool ascending) =>
                                                      _sort<num>(
                                                          (User d) => d.score,
                                                          columnIndex,
                                                          ascending)),
                                              DataColumn(
                                                label: const Text('Email',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                            source: _userDataSource),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text("Choose Your Event",
                                      style: TextStyle(color: Colors.white))))
                        ],
                      ),

                      // FloatingActionButton(
                      //   elevation: 0,
                      //   foregroundColor: Color(0xFF6B872B),
                      //   backgroundColor: Colors.transparent,
                      //   onPressed: () {
                      //     _scaffoldKey.currentState.openDrawer();
                      //   },
                      //   child: Icon(Icons.menu),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          drawer: NavigationDrawer(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/comingsoon.png"),
                  fit: BoxFit.cover),
            ),
            // child:
            //  Padding(
            //   padding: EdgeInsets.only(
            //       left: MediaQuery.of(context).size.width / 3, top: 80.0),
            //   child: Text("Coming Soon!",
            //       style: TextStyle(
            //         fontSize: 24.0,
            //       )),
            // ),
          ),
        );
      }
    } else {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Theme.of(context).brightness == Brightness.light
                      ? AssetImage("images/gifs/loaderlight.gif")
                      : AssetImage("images/gifs/loaderdark.gif"),
                  fit: BoxFit.fill)),
        ),
      );
    }
  }

  Widget backButton() {
    return NeumorphicButton(
      onPressed: () {
       Navigator.of(context).pop();
      },
      margin: EdgeInsets.all(10),
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
            Icons.arrow_back,
            color: Colors.white,
            // size: 25,
          ),
        ),
      ),
    );
  }

  Widget getNu(Widget c) {
    return Neumorphic(
        //margin: EdgeInsets.symmetric(horizontal: 10),
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
        child: c);
  }

  Future<dynamic> getctfScoreData() async {
    String apiUrl = "https://ctf.nitdgplug.org/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getdigitalfortressScoreData() async {
    String apiUrl = "https://digitalfortress.nitdgplug.org/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getfreemexScoreData() async {
    String apiUrl = "https://freemex.arhn.co.in/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getfreeplScoreData() async {
    String apiUrl = "https://freepl.nitdgplug.org/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getinterficioScoreData() async {
    String apiUrl = "https://interficio.nitdgplug.org/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getothScoreData() async {
    String apiUrl = "https://oth.nitdgplug.org/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<dynamic> getroadrangerScoreData() async {
    String apiUrl = "https://roadranger.avskr.in/api/scoreboard";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<Null> getData() async {
    _refreshIndicatorKey.currentState?.show();
    if (comingsoon == false) {
//      if (roadranger == true)
//        roadrangerUsers = await getroadrangerScoreData();
//      else
//        roadrangerUsers = List();

      if (ctf == true)
        ctfUsers = await getctfScoreData();
      else
        ctfUsers = List();

      if (digitalfortress == true)
        digitalfortressUsers = await getdigitalfortressScoreData();
      else
        digitalfortressUsers = List();

//      if (freepl == true)
//        freeplUsers = await getfreeplScoreData();
//      else
//        freeplUsers = List();

      if (freemex == true)
        freemexUsers = await getfreemexScoreData();
      else
        freemexUsers = List();

//      if (interficio == true)
//        interficioUsers = await getinterficioScoreData();
//      else
//        interficioUsers = List();

      if (oth == true)
        othUsers = await getothScoreData();
      else
        othUsers = List();

      await Future.delayed(Duration(seconds: 4));
      setState(() {
        dataRecieved = true;
      });
    }
  }

  Future<Null> getDataOnRefresh() async {
//    if (roadranger == true)
//      roadrangerUsers = await getroadrangerScoreData();
//    else
//      roadrangerUsers = List();

    if (ctf == true)
      ctfUsers = await getctfScoreData();
    else
      ctfUsers = List();

    if (digitalfortress == true)
      digitalfortressUsers = await getdigitalfortressScoreData();
    else
      digitalfortressUsers = List();

//    if (freepl == true)
//      freeplUsers = await getfreeplScoreData();
//    else
//      freeplUsers = List();

    if (freemex == true)
      freemexUsers = await getfreemexScoreData();
    else
      freemexUsers = List();

//    if (interficio == true)
//      interficioUsers = await getinterficioScoreData();
//    else
//      interficioUsers = List();

    if (oth == true)
      othUsers = await getothScoreData();
    else
      othUsers = List();

    createUserList(Selected);
    setState(() {
      dataRecieved = true;
    });
  }

  //optimize by calling setState once
  createUserList(String s) {
    switch (s) {
//      case "Roadranger":
//        _uSeR = List();
//        for (int i = 0; i < roadrangerUsers.length; i++) {
//          User temp = new User(
//              roadrangerUsers[i]["rank"],
//              roadrangerUsers[i]["name"],
//              roadrangerUsers[i]["email"],
//              roadrangerUsers[i]["score"]);
//          _uSeR.add(temp);
//        }
//        break;

      case "CTF":
        _uSeR = List();
        for (int i = 0; i < ctfUsers.length; i++) {
          User temp = new User(ctfUsers[i]["rank"], ctfUsers[i]["name"],
              ctfUsers[i]["email"], ctfUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;

      case "Digitalfortress":
        _uSeR = List();
        for (int i = 0; i < digitalfortressUsers.length; i++) {
          User temp = new User(
              digitalfortressUsers[i]["rank"],
              digitalfortressUsers[i]["name"],
              digitalfortressUsers[i]["email"],
              digitalfortressUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;

      case "Freemex":
        _uSeR = List();
        for (int i = 0; i < freemexUsers.length; i++) {
          User temp = new User(i + 1, freemexUsers[i]["name"],
              freemexUsers[i]["email"], freemexUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;

//      case "Freepl":
//        _uSeR = List();
//        for (int i = 0; i < freeplUsers.length; i++) {
//          User temp = new User(i + 1, freeplUsers[i]["name"],
//              freeplUsers[i]["email"], freeplUsers[i]["score"]);
//          _uSeR.add(temp);
//        }
//        break;

//      case "Interficio":
//        _uSeR = List();
//        for (int i = 0; i < interficioUsers.length; i++) {
//          User temp = new User(
//              interficioUsers[i]["rank"],
//              interficioUsers[i]["name"],
//              interficioUsers[i]["email"],
//              interficioUsers[i]["score"]);
//          _uSeR.add(temp);
//        }
//        break;
      case "OTH":
        _uSeR = List();
        for (int i = 0; i < othUsers.length; i++) {
          User temp = new User(othUsers[i]["rank"], othUsers[i]["name"],
              othUsers[i]["rank"], othUsers[i]["score"]);
          _uSeR.add(temp);
        }
        break;
      case "None":
        _uSeR = List();
        break;
      default:
        break;
    }
    setState(() {
      _userDataSource = UserDataSource();
      dataRecieved = true;
    });
  }
}

//  Add another Item in DropDownMenu --> Add one more Future Function--> Add another entry in createUserList
