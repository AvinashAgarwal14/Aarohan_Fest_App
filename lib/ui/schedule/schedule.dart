import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/drawer.dart';
import './day1.dart';
import './day2.dart';
import './day3.dart';
import './day4.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);
  @override
  _ScheduleState createState() => _ScheduleState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _ScheduleState extends State<Schedule> {
  final List<String> week = ["THUR", "FRI", "SAT", "SUN"];
  final List arrayDay = ["1", "2", "3", "4"];
  var presentKey;
  final List selectDaySchedule = [
    DayOneSchedule(),
    DayTwoSchedule(),
    DayThreeSchedule(),
    DayFourSchedule()
  ];

  GlobalKey<ScaffoldState> _scaffoldKeyForSchedule =
      new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  final EdgeInsets margin;
  _ScheduleState({this.margin});

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark));
    setState(() {
      presentKey = 0;
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
          child: CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                iconTheme: IconThemeData(
                  color: Color(0xFF6B872B),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Timeline',
                    style: GoogleFonts.josefinSans(
                      fontSize: 30,
                      color: Color(0xFF6B872B),
                    ),
                  ),
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      new Image.asset(
                        "assets/schedule.png",
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.6),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    new Container(
                      margin: margin,
                      alignment: Alignment.center,
                      padding: new EdgeInsets.only(left: 30.0, top: 20.0),
                      height: 90.0,
                      decoration: new BoxDecoration(
                        color: Color(0xff292D32),
                        border: new Border(
                          bottom: new BorderSide(
                              width: 0.5,
                              color: const Color.fromRGBO(204, 204, 204, 1.0)),
                        ),
                      ),
                      child: new ListView.builder(
                        cacheExtent: MediaQuery.of(context).size.height * 5,
                        itemCount: week.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return new GestureDetector(
                            onTap: () {
                              setState(() {
                                print(presentKey);
                                presentKey = index;
                              });
                            },
                            child: SizedBox(
                              width: 80.0,
                              child: Column(
                                children: <Widget>[
                                  new Text(
                                    week[index],
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 12,
                                        color: Colors.white //(0xFF6B872B),
                                        ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.concave,
                                        boxShape: NeumorphicBoxShape.circle(),
                                        depth: 4.0,
                                        intensity: 1.0,
                                        lightSource: LightSource.topLeft,
                                        shadowLightColor:
                                            Colors.grey[700].withOpacity(0.6),
                                        shadowDarkColor: Colors.black,
                                      ),
                                      child: new Container(
                                        width: 40.0,
                                        height: 40.0,
                                        alignment: Alignment.center,
                                        decoration: new BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF63d471)
                                                .withOpacity(0.5),
                                            width: 1.5,
                                            style: BorderStyle.solid,
                                          ),
                                          shape: BoxShape.circle,
                                          // color: (presentKey == index)
                                          //     ? const Color.fromRGBO(
                                          //         204, 204, 204, 0.3)
                                          //     : Colors.transparent,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF396b4b),
                                              Color(0xFF78e08f),
                                            ],
                                          ),
                                        ),
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Text(
                                              arrayDay[index].toString(),
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            (presentKey == index) // Dot
                                                ? new Container(
                                                    padding:
                                                        new EdgeInsets.only(
                                                            top: 3.0),
                                                    width: 3.0,
                                                    height: 3.0,
                                                    decoration:
                                                        new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Color(
                                                                0xFF505194)),
                                                  )
                                                : new Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //The list
                    Container(
                        // color: Colors.white,
                        child: selectDaySchedule[presentKey])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
