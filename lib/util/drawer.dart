import 'package:flutter/material.dart';
import '../ui/search_by_tags/tags.dart';
//import '../ui/maps/map.dart';
import '../ui/scoreboard/scoreboard.dart';
import '../ui/schedule/schedule.dart';
import '../ui/eurekoin/eurekoin.dart';
import '../ui/about_us/about_us.dart';
import '../ui/sponsors/sponsors.dart';
import '../util/navigator_transitions/slide_left_transitions.dart';
import '../ui/contact_us/contact_us.dart';
import '../ui/contributors/contributors.dart';
import '../ui/interficio/interficio.dart';
import 'package:aavishkarapp/ui/games/home_page.dart';
import 'package:flutter/services.dart';
import 'package:aavishkarapp/ui/dashboard/dashboard.dart';

class NavigationDrawer extends StatefulWidget {

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Drawer(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          child: ListTileTheme(
            iconColor: Color.fromRGBO(255, 255, 255, 1.0),
            textColor: Color.fromRGBO(255, 255, 255, 1.0),
            selectedColor: Theme.of(context).primaryColor.withOpacity(1.0),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(0.0),
                child: Image.asset("images/gifs/pacman.gif", fit: BoxFit.cover),
              ),
              ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text(
                    "Dashboard",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                          .push(SlideLeftRoute(widget: Dashboard()));
                  }),
              ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                  ),
                  title: Text(
                    "Eurekoin Wallet",
                  ),
                  onTap: () {
                    Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                    Navigator.of(context)
                          .push(SlideLeftRoute(widget: EurekoinHomePage()));
                    }
                  ),
              ListTile(
                leading: Icon(
                  Icons.casino,
                ),
                title: Text(
                  "Eurekoin Casino",
                ),
                onTap: (() {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context)
                        .push(SlideLeftRoute(widget: HomePage()));
                }),
              ),
              ListTile(
                leading: Icon(
                  Icons.access_time,
                ),
                title: Text(
                  "Schedule",
                ),
                onTap: () {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context)
                        .push(SlideLeftRoute(widget: Schedule()));
                  }
              ),
              ListTile(
                  title: Text("Utilities",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold))),
              Divider(),
              ListTile(
                  leading: Icon(
                    Icons.score,
                  ),
                  title: Text(
                    "Scoreboard",
                  ),
                  onTap: () {
                    Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                    Navigator.of(context)
                          .push(SlideLeftRoute(widget: Scoreboard()));
                  }),
              ListTile(
                leading: Icon(
                  Icons.youtube_searched_for,
                ),
                title: Text(
                  "Tags",
                ),
                onTap: () {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context)
                        .push(SlideLeftRoute(widget: SearchByTags()));
                  }
              ),
//              ListTile(
//                leading: Icon(Icons.my_location,),
//                title: Text("Maps",),
//                onTap: (() {
//                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
//                    Navigator.of(context)
//                        .push(SlideLeftRoute(widget: MapPage()));
//                }),
//              ),
              ListTile(
                leading: Icon(
                  Icons.map,
                ),
                title: Text(
                  "Interficio",
                ),
                onTap: (() {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context).push(SlideLeftRoute(widget: MyApp()));
                }),
              ),

              ListTile(
                  title: Text("About Us",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold))),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(
                  "Sponsors",
                ),
                onTap: (() {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context)
                        .push(SlideLeftRoute(widget: Sponsors()));
                }),
              ),
              ListTile(
                  leading: Icon(
                    Icons.call,
                  ),
                  title: Text(
                    "Contact Us",
                  ),
                  onTap: () {
                    Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                    Navigator.of(context)
                          .push(SlideLeftRoute(widget: ContactUs()));
                  }),
              ListTile(
                  leading: Icon(
                    Icons.accessibility,
                  ),
                  title: Text(
                    "Contributors",
                  ),
                  onTap: () {
                    Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                    Navigator.of(context)
                          .push(SlideLeftRoute(widget: Contributors()));
                  }),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About Aarohan"),
                onTap: (() {
                  Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  Navigator.of(context)
                        .push(SlideLeftRoute(widget: AboutUsPage()));
                }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
