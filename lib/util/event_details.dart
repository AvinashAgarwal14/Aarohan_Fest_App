import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        backgroundColor: Colors.black,
        // key: _scaffoldKeyForSchedule,
        // drawer: NavigationDrawer(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                elevation: 0,
                backgroundColor: Colors.black,
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.item.title,
                    style: GoogleFonts.josefinSans(
                      fontSize: 25,
                      color: themeData.primaryColor,
                    ),
                  ),
                  background: Hero(
                    tag: widget.item.imageUrl,
                    child: CachedNetworkImage(
                      height: _appBarHeight-200,
                      width: MediaQuery.of(context).size.width,
                      errorWidget: (context, url, error) {
                        print("Could not load content");
                        return Image.asset("images/imageplaceholder.png");
                      },
                      placeholder: (context, url) =>
                          Image.asset("images/imageplaceholder.png"),
                      imageUrl: widget.item.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Icon(Icons.date_range, color: Colors.white),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(
                                widget.item.date,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          (widget.item.location != "nil")
                              ? Column(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        color: Colors.white),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Hero(
                                        tag:
                                            "${widget.item.title}${widget.item.location}",
                                        child: Text(widget.item.location,
                                            style:
                                                TextStyle(color: Colors.white)))
                                  ],
                                )
                              : Container(),
                          Column(
                            children: <Widget>[
                              Icon(Icons.category, color: Colors.white),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(widget.item.tag,
                                  style: TextStyle(color: Colors.white))
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: themeData.primaryColor,
                      thickness: 2,
                    ),
                    (widget.item.contact != null)
                        ? Column(
                            children: [
                              new DetailCategory(
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
                              Divider(
                                color: themeData.primaryColor,
                                thickness: 2,
                              ),
                            ],
                          )
                        : Container(),
                    (widget.item.link != "nil")
                        ? Column(
                            children: [
                              new DetailCategory(
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
                              Divider(
                                color: themeData.primaryColor,
                                thickness: 2,
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Text(
                        widget.item.body,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                    )
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
