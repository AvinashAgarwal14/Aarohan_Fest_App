import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/event.dart';
import './web_render.dart';
import './detailSection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'drawer.dart';

class EventDetails extends StatefulWidget {
  final EventItem item;
  EventDetails({this.item}); // : super(key: key);

  @override
  EventDetailsState createState() => new EventDetailsState();
}

GlobalKey<ScaffoldState> _scaffoldKeyForSchedule =
    new GlobalKey<ScaffoldState>();
final double _appBarHeight = 256.0;
AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

final EdgeInsets edgeInsets = EdgeInsets.all(10);
var margin = EdgeInsets.all(10);

enum AppBarBehavior { normal, pinned, floating, snapping }

class EventDetailsState extends State<EventDetails> {
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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Theme(
      data: themeData,
      child: Scaffold(
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
          child: SingleChildScrollView(
            child: Container(
              child: Neumorphic(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Hero(
                            tag: widget.item.imageUrl,
                            child: CachedNetworkImage(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              errorWidget: (context, url, error) {
                                print("Could not load content");
                                return Image.asset(
                                    "images/imageplaceholder.png");
                              },
                              placeholder: (context, url) =>
                                  Image.asset("images/imageplaceholder.png"),
                              imageUrl: widget.item.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),

                          NeumorphicButton(
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
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          // size: 25,
                                        ),
                                      ),
                                    ),
                                  ),

                          
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Neumorphic(
                              padding: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                color: Color(0xFF292D32),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 5,
                                intensity: 1,
                                lightSource: LightSource.topLeft,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.5),
                                shadowDarkColor: Colors.black,
                              ),
                              child: Container(
                                width: 90,
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.date_range, color: Colors.white),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text(
                                      widget.item.date,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Neumorphic(
                              padding: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                color: Color(0xFF292D32),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 5,
                                intensity: 1,
                                lightSource: LightSource.topLeft,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.5),
                                shadowDarkColor: Colors.black,
                              ),
                              child: Container(
                                width: 90,
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.category, color: Colors.white),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text(widget.item.tag,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (widget.item.contact != null)
                          ? Neumorphic(
                              margin: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                color: Color(0xFF292D32),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 5,
                                intensity: 1,
                                lightSource: LightSource.topLeft,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.5),
                                shadowDarkColor: Colors.black,
                              ),
                              child: new DetailCategory(
                                icon: Icons.call,
                                children: <Widget>[
                                  new DetailItem(
                                    tooltip: 'Send message',
                                    onPressed: () {
                                      launch(
                                          "tel:+91${widget.item.contact.substring(0, 10)}");
                                    },
                                    lines: <String>[
                                      '+91 ${widget.item.contact.substring(0, 10)}',
                                      '${widget.item.contact.substring(11)}',
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      (widget.item.link != "nil")
                          ? Neumorphic(
                              margin: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                color: Color(0xFF292D32),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12.0),
                                ),
                                depth: 5,
                                intensity: 1,
                                lightSource: LightSource.topLeft,
                                shadowLightColor:
                                    Colors.grey[700].withOpacity(0.5),
                                shadowDarkColor: Colors.black,
                              ),
                              child: new DetailCategory(
                                icon: Icons.link,
                                children: <Widget>[
                                  new DetailItem(
                                    tooltip: 'Open Link',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new WebRender(
                                                link: widget.item.link)),
                                      );
                                    },
                                    lines: <String>[
                                      "${widget.item.link}",
                                      "Link"
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20.0),
                        child: Text(
                          widget.item.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Text(
                          widget.item.body,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        )),
      ),
    );
  }
}
