import 'package:arhn_app_2021/util/drawer2.dart';
import 'package:arhn_app_2021/util/web_render.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class Prelims extends StatefulWidget {
  @override
  _PrelimsState createState() => _PrelimsState();
}

class _PrelimsState extends State<Prelims> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Map<String, dynamic> form = {'key': '', 'name': '', 'link': ''};
  List formList = [];

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(150000);
    databaseReference = database.reference().child("Prelims");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      formList.add({
        'key': event.snapshot.key,
        'name': event.snapshot.value['name'],
        'link': event.snapshot.value['link']
      });
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = formList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      formList[formList.indexOf(oldEntry)] = {
        'key': event.snapshot.key,
        'name': event.snapshot.value['name'],
        'link': event.snapshot.value['link']
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavigationDrawer('/ui/prelims'),
        body: Container(
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
            children: [
              Row(
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    margin: EdgeInsets.only(top: 10, left: 10),
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
                    margin: EdgeInsets.only(top: 20, left: 30),
                    child: Text(
                      "Prelims",
                      style: GoogleFonts.josefinSans(
                          fontSize: 30, color: Colors.white //(0xFF6B872B),
                          ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: (formList.length == 0)
                    ? Container()
                    : ListView.builder(
                        itemCount: formList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WebRender(
                                      link: formList[index]['link'])));
                            },
                            child: Neumorphic(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 8.0,
                                intensity: 1.0,
                                lightSource: LightSource.top,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.55),
                                shadowDarkColor: Colors.black,
                              ),
                              child: Container(
                                height: 80,
                                //padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF292D32),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            child: Center(
                                                child: Text(
                                                    formList[index]['name'])))),
                                    SizedBox(height: 10),
                                    Container(
                                      color: Color(0xFF03A062),
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Center(
                                          child: Icon(
                                        Icons.link,
                                        color: Colors.white,
                                        size: 35,
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
