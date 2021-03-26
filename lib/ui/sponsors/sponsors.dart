import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/sponsor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../util/drawer2.dart';

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  GlobalKey<ScaffoldState> _scaffoldKeyForSchedule =
      new GlobalKey<ScaffoldState>();
  List<SponsorItem> sponsorList = List();
  SponsorItem sponsorItem, b;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<SponsorItem>> sponsorsByCategories;
  int indexOfWidget;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("Sponsors");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    indexOfWidget = 0;
  }

  @override
  Widget build(BuildContext context) {
    indexOfWidget = 0;
    return Scaffold(
        key: _scaffoldKeyForSchedule,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70.0,
          leading: NeumorphicButton(
            onPressed: () {
              _scaffoldKeyForSchedule.currentState.openDrawer();
            },
            margin: EdgeInsets.only(left: 10.0),
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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF32393f),
          title: Text(
            "Sponsors",
            style: GoogleFonts.josefinSans(
                fontSize: 26, color: Colors.white //(0xFF6B872B),
                ),
          ),
        ),
        drawer: NavigationDrawer("${ModalRoute.of(context).settings.name}"),
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
          child: sponsorList.length > 0
              ? ListView.builder(
                  cacheExtent: MediaQuery.of(context).size.height * 5,
                  itemCount: sponsorList.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    if (indexOfWidget < sponsorList.length - 1) {
                      if ((sponsorList[index].priority) > 1) {
                        int p = indexOfWidget;
                        indexOfWidget = indexOfWidget + 1;
                        // print("------$a----- $p------");
                        return majorSponsor(
                            sponsorList[p], sponsorList[indexOfWidget++]);
                      } else {
                        indexOfWidget = index + 1;
                        print("----Gangnum 2 $index");
                        return majorSponsor(sponsorList[index], b);
                      }
                    } else if ((indexOfWidget == sponsorList.length - 1) &&
                        (sponsorList.length % 2 != 0))
                      return majorSponsor(sponsorList[indexOfWidget++], b);
                  })
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              Theme.of(context).brightness == Brightness.light
                                  ? AssetImage("images/gifs/loaderlight.gif")
                                  : AssetImage("images/gifs/loaderdark.gif"),
                          fit: BoxFit.fill)),
                ),
        ));
  }

  int i = 0;
  void _onEntryAdded(Event event) {
    setState(() {
      //sponsorsByCategories[event.snapshot.value["category"]].add(SponsorItem.fromSnapshot(event.snapshot));
      sponsorList.add(SponsorItem.fromSnapshot(event.snapshot));
      sponsorList.sort((SponsorItem a, SponsorItem b) {
        return (a.priority).compareTo(b.priority);
      });
    });
  }

  Widget majorSponsor(SponsorItem indexOfWidget, SponsorItem c) {
    if (c == b)
      return Column(children: <Widget>[
        prioritySponsor(indexOfWidget),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.black,
            height: 5.0,
          ),
        )
      ]);
    else {
      return Column(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(child: prioritySponsor(indexOfWidget)),
              // Expanded(child:SizedBox()),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: prioritySponsor(c),
              )
            ])
      ]);
    }
  }

  prioritySponsor(SponsorItem s) {
    int p = s.priority;
    switch (p) {
      case 0:
        {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: s.description == ""
                      ? EdgeInsets.all(0.0)
                      : EdgeInsets.all(12.0),
                  child: Center(
                      child: s.description != ""
                          ? Text(
                              s.description,
                              style: TextStyle(fontSize: 20.0),
                            )
                          : Container()),
                ),
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) {
                          print("Could not load content");
                          return Image.asset("images/imageplaceholder.png");
                        },
                        placeholder: (context, url) =>
                            Image.asset("images/imageplaceholder.png"),
                        imageUrl: s.imageUrl,
                        fit: BoxFit.fill,
                      )),
                ),
              ],
            ),
          );
        }
      case 1:
        {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: s.description == ""
                      ? EdgeInsets.all(0.0)
                      : EdgeInsets.all(12.0),
                  child: Center(
                      child: s.description != ""
                          ? Text(
                              s.description,
                              style: TextStyle(fontSize: 20.0),
                            )
                          : Container()),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) {
                        print("Could not load content");
                        return Image.asset("images/imageplaceholder.png");
                      },
                      placeholder: (context, url) =>
                          Image.asset("images/imageplaceholder.png"),
                      imageUrl: s.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

      case 2:
        {
          return Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 3,
            child: ClipRRect(
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) {
                    print("Could not load content");
                    return Image.asset("images/imageplaceholder.png");
                  },
                  placeholder: (context, url) =>
                      Image.asset("images/imageplaceholder.png"),
                  imageUrl: s.imageUrl,
                  fit: BoxFit.fill,
                )),
          );
        }
      case 3:
        {
          return Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 6,
            child: ClipRRect(
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) {
                    print("Could not load content");
                    return Image.asset("images/imageplaceholder.png");
                  },
                  placeholder: (context, url) =>
                      Image.asset("images/imageplaceholder.png"),
                  imageUrl: s.imageUrl,
                  fit: BoxFit.fill,
                )),
          );
        }
    }
  }
}
