import 'dart:convert';

import 'package:arhn_app_2021/util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EurekoinLeaderBoard extends StatefulWidget {
  EurekoinLeaderBoard(); // : super(key: key);

  @override
  EurekoinLeader createState() => new EurekoinLeader();
}

GlobalKey<ScaffoldState> _scaffoldKeyForSchedule =
    new GlobalKey<ScaffoldState>();

final EdgeInsets edgeInsets = EdgeInsets.all(10);
var margin = EdgeInsets.all(10);

enum AppBarBehavior { normal, pinned, floating, snapping }

class EurekoinLeader extends State<EurekoinLeaderBoard> {
  List _data = [];
  bool _isLoading = false;

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
    _fetchLeaderboard();
  }

  Future _fetchLeaderboard() async {
    setState(() {
      _isLoading = true;
    });
    String url = "https://eurekoin.nitdgplug.org/api/leaderboard/";
    http.Response response = await http.get(url);
    Map userMap = json.decode(response.body);
    userMap.forEach((key, value) {
      _data.add({"name": key, "eurekoins": value});
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Theme(
      data: themeData,
      child: Scaffold(
        key: _scaffoldKeyForSchedule,
        drawer: NavigationDrawer(),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
          height: MediaQuery.of(context).size.height,
          child: _isLoading
              ? Container()
              : CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      menuButton(),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Leaderboard",
                        style: GoogleFonts.josefinSans(
                            fontSize: 30, color: Colors.white //(0xFF6B872B),
                            ),
                      ),
                    ],
                  )),
                  SliverToBoxAdapter(child: getToRankView()),
                  SliverList(
                      delegate: SliverChildListDelegate(List.generate(
                          _data.length, (index) => listTile(index)).toList())),
                ]),
        )),
      ),
    );
  }

  Widget listTile(int index) {
    return Container(
      margin: EdgeInsets.all(10),
      child: getNu(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            style: BorderStyle.solid,
            width: 1.5,
            color: Colors.grey[700].withOpacity(0.3),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Row(children: [
          SizedBox(
            width: 10,
          ),
          Text(
            "${index + 1}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://otlibrary.com/wp-content/gallery/king-penguin/KingPenguin_C.jpg"),
            radius: 30,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _data[index]["name"],
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${_data[index]["eurekoins"]} Coins",
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ]),
      )),
    );
  }

  Widget getTopRankTile(String name, int position, String imageUrl) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              getNuCirculer(CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 40,
              )),
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                alignment: Alignment.center,
                width: 30,
                padding: EdgeInsets.symmetric(vertical: 2),
                margin: EdgeInsets.only(top: 70, left: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Color(0xFF63d471),
                ),
                child: Text(
                  "${position}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 80,
            alignment: Alignment.center,
            // margin: EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                name.substring(0, name.indexOf(" ")),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getToRankView() {
    return Stack(
      children: [
        getTopRankTile(_data[0]["name"], 1,
            "https://otlibrary.com/wp-content/gallery/king-penguin/KingPenguin_C.jpg"),

        Container(
          margin: EdgeInsets.only(top: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTopRankTile(_data[1]["name"], 2,
                  "https://otlibrary.com/wp-content/gallery/king-penguin/KingPenguin_C.jpg"),
              SizedBox(
                width: 70,
              ),
              getTopRankTile(_data[2]["name"], 3,
                  "https://otlibrary.com/wp-content/gallery/king-penguin/KingPenguin_C.jpg")
            ],
          ),
        )

        //  menuButton()
      ],
    );
  }

  Widget menuButton() {
    return NeumorphicButton(
      onPressed: () {
        _scaffoldKeyForSchedule.currentState.openDrawer();
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
            Icons.menu,
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
          lightSource: LightSource.top,
          shadowLightColor: Colors.grey[700].withOpacity(0.5),
          shadowDarkColor: Colors.black,
        ),
        child: c);
  }

  Widget getNuCirculer(Widget c) {
    return Neumorphic(
        //margin: EdgeInsets.symmetric(horizontal: 10),
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.circle(),
          depth: 7.5,
          intensity: 1.0,
          lightSource: LightSource.topLeft,
          shadowLightColor: Colors.grey[700].withOpacity(0.6),
          shadowDarkColor: Colors.black,
        ),
        child: c);
  }
}
