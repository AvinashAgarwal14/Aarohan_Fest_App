import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/drawer.dart';
// import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/event.dart';
import '../../util/event_details.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'search_box.dart';

Map<String, List<EventItem>> eventsByTags;

class SearchByTags extends StatefulWidget {
  @override
  _SearchByTagsState createState() => _SearchByTagsState();
}

class _SearchByTagsState extends State<SearchByTags> {
  var _selectedTag = 'All';

  List<String> _tags = <String>[
    'Logic',
    'Strategy',
    'Mystery',
    'Innovation',
    'Treasure Hunt',
    'Coding',
    'Sports',
    'Robotics',
    'Workshops',
    'Buisness'
  ];

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

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

    eventsByTags = {
      'All': new List(),
      'Logic': new List(),
      'Strategy': new List(),
      'Mystery': new List(),
      'Innovation': new List(),
      'Treasure Hunt': new List(),
      'Coding': new List(),
      'Sports': new List(),
      'Robotics': new List(),
      'Workshops': new List(),
      'Buisness': new List()
    };

    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 5)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> choiceChips = _tags.map<Widget>((String name) {
      Color chipColor;
      chipColor = Colors.blue.withOpacity(0.8);
      return ChoiceChip(
        key: new ValueKey<String>(name),
        backgroundColor: chipColor,
        label: new Text(name, style: TextStyle(color: Colors.white)),
        selected: _selectedTag == name,
        selectedColor: chipColor.withOpacity(0.3),
        onSelected: (bool value) {
          setState(() {
            _selectedTag = value ? name : _selectedTag;
          });
        },
      );
    }).toList();

    final List<Widget> cardChildren = <Widget>[
      new Wrap(
          children: choiceChips.map((Widget chip) {
        return new Padding(
          padding: const EdgeInsets.all(2.0),
          child: chip,
        );
      }).toList())
    ];

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text("Tags"),
      // ),
      drawer: NavigationDrawer(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(50.0, 10.0, 30.0, 0.0),
                  child: Text(
                    "Search",
                    style: GoogleFonts.josefinSans(
                      fontSize: 35,
                      color: Color(0xFF6B872B),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: SearchTab(
                    eventsList: eventsByTags['All'],
                  ),
                ),
              ],
            ),
            SlidingUpPanel(
              minHeight: 65.0,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              panel: Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 35,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      )
                    ],
                  ),
                  SizedBox(height: 13.0),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Container(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: cardChildren,
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Color(0xFF505194),
                  ),
                  Container(
                      child: Expanded(
                    child: ListView.builder(
                        cacheExtent: MediaQuery.of(context).size.height * 3,
                        itemCount: eventsByTags[_selectedTag].length,
                        itemBuilder: (context, position) {
                          return Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new EventDetails(
                                                  item:
                                                      eventsByTags[_selectedTag]
                                                          [position])),
                                    );
                                  },
                                  child: SearchByTagsCards(
                                      eventCard: eventsByTags[_selectedTag]
                                          [position])));
                        }),
                  )),
                  SizedBox(height: 55.0),
                ],
              ),
            ),
            FloatingActionButton(
              elevation: 0,
              foregroundColor: Color(0xFF6B872B),
              backgroundColor: Colors.transparent,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      //print(event.snapshot.value);
      eventsByTags["All"].add(EventItem.fromSnapshot(event.snapshot));
      eventsByTags[event.snapshot.value["tag"]]
          .add(EventItem.fromSnapshot(event.snapshot));
      //print(eventsByTags);
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry =
        eventsByTags[event.snapshot.value["tag"]].singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByTags[event.snapshot.value["tag"]]
              [eventsByTags[event.snapshot.value["tag"]].indexOf(oldEntry)] =
          EventItem.fromSnapshot(event.snapshot);
    });
  }
}

class SearchByTagsCards extends StatefulWidget {
  SearchByTagsCards({Key key, this.eventCard}) : super(key: key);

  final EventItem eventCard;

  @override
  _SearchByTagsCardsState createState() => _SearchByTagsCardsState();
}

class _SearchByTagsCardsState extends State<SearchByTagsCards> {
  // PaletteGenerator paletteGenerator;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceForUpdate;
  Color cardColor;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.eventCard.color != 'invalid') {
      if (widget.eventCard.color == 'null')
        cardColor = Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xFF505194);
      else {
        String valueString = widget.eventCard.color
            .split('(0x')[1]
            .split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        cardColor = new Color(value);
      }
    } else {
      databaseReferenceForUpdate = database.reference().child("Events");
      updatePaletteGenerator();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardItem = new Card(
        color: //(paletteGenerator != null)
            // ? paletteGenerator.lightVibrantColor?.color:
            cardColor,
        child: new Column(
          children: <Widget>[
            new ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(5.0),
                    topRight: new Radius.circular(5.0)),
                child: Container(
                  height: 256.0,
                  child: SizedBox.expand(
                      child: Image.network(
                          //placeholder: (context, url) =>
                          //     Image.asset("images/imageplaceholder.png"),
                          widget.eventCard.imageUrl,
                          fit: BoxFit.cover,
                          height: 256.0)),
                )),
            ListTile(
              title: new Text(widget.eventCard.title),
              subtitle: new Text(widget.eventCard.date),
            )
          ],
        )
        );

    return cardItem;
  }

  Future<void> updatePaletteGenerator() async {
    // paletteGenerator = await PaletteGenerator.fromImageProvider(
    //   NetworkImage(widget.eventCard.imageUrl),
    //   maximumColorCount: 5,
    // );
    // setState(() {});
    // updateNewsFeedPostColor(paletteGenerator.lightVibrantColor?.color);
  }

  void updateNewsFeedPostColor(Color color) {
    databaseReferenceForUpdate
        .child(widget.eventCard.key)
        .update({'color': color.toString()});
  }
}
