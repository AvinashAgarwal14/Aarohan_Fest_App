import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../model/schedule.dart';
import 'package:firebase_database/firebase_database.dart';

class DayThreeSchedule extends StatefulWidget {
  @override
  _DayThreeScheduleState createState() => _DayThreeScheduleState();
}

class _DayThreeScheduleState extends State<DayThreeSchedule> {
  final double dotSize = 12.0;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List<ScheduleItem> scheduleList;

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

    scheduleList = new List();
    databaseReference = database.reference().child("Schedule").child("Day3");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(color: Color(0xff32393f)),
      child: Stack(
        children: <Widget>[
          _buildTimeline(),
          (_buildSchedule().length != 0)
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(children: _buildSchedule()))
              : Container(
                  height: 2.0,
                  child: LinearProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFF505194))))
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 42.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  List _buildSchedule() {
    var size = MediaQuery.of(context).size;
    return scheduleList.map((schedule) {
      return new Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: -2,
            intensity: 1,
            lightSource: LightSource.topLeft,
            color: Color(0xFF292D32),
          ),
          child: Container(
            width: size.width * 0.95,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                  child: new Container(
                    height: dotSize,
                    width: dotSize,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: (schedule.completed == true)
                            ? Colors.red
                            : Color(0xff78e08f)),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "${schedule.name}",
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "${schedule.category}",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white, //color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Text(
                    "${schedule.time}",
                    style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white, //color: Colors.grey
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onEntryAdded(Event event) {
    setState(() {
      scheduleList.add(ScheduleItem.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = scheduleList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      scheduleList[scheduleList.indexOf(oldEntry)] =
          ScheduleItem.fromSnapshot(event.snapshot);
    });
  }
}
