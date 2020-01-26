import 'package:aavishkarapp/model/event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aavishkarapp/util/event_details.dart';
import 'package:palette_generator/palette_generator.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<EventItem> feed;
  List<EventItem> filteredFeed;
  var searchController = TextEditingController();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    feed = new List();
    filteredFeed = new List();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(15000000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);

    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredFeed = feed;
        });
      } else {
        setState(() {
          _searchText = searchController.text;
        });
      }
    });
  }

  void _onEntryAdded(Event event) {
    setState(() {
      feed.add(EventItem.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = feed.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      feed[feed.indexOf(oldEntry)] = EventItem.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchText.isNotEmpty) {
    List<EventItem> tempList = new List();
    for (int i = 0; i < filteredFeed.length; i++) {
      if (filteredFeed[i].title.toLowerCase().contains(_searchText.toLowerCase())) {
        tempList.add(filteredFeed[i]);
      }
    }
    filteredFeed = tempList;
  }
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: "Search Events"),
            ),
          ),
          (filteredFeed.length != 0) ? Expanded(
                      child: ListView.builder(
              cacheExtent: MediaQuery.of(context).size.height * 3,
              itemCount: filteredFeed.length,
              itemBuilder: (BuildContext context, position) {
                return GestureDetector(
                  onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new EventDetails(
                                                item: filteredFeed
                                                [position])),
                                      );
                                    },
                    child: EventCard(cardItem: filteredFeed[position]));
              }),
          ) : Expanded(child:Center(child: Text('There is no such event!')))
        ],
      ),
    );
  }
}

  class EventCard extends StatefulWidget {
    @override
    
    EventCard({Key key, this.cardItem}) : super(key: key);
    final EventItem cardItem;


    _EventCardState createState() => _EventCardState();
  }
  
  class _EventCardState extends State<EventCard> {
  PaletteGenerator paletteGenerator;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceForUpdate;
  Color cardColor;

  @override
    void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.cardItem.color != 'invalid') {
      if (widget.cardItem.color == 'null')
        cardColor = Theme.of(context).brightness==Brightness.light ?Colors.white:Color(0xFF505194);
      else {
        String valueString = widget.cardItem.color
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
      return GestureDetector(
    child: Card(
      color: (paletteGenerator != null)
            ? paletteGenerator.lightVibrantColor?.color
            : cardColor,
        child: new Column(
          children: <Widget>[
            new ClipRRect(
                  borderRadius: new BorderRadius.only(
                      topLeft: new Radius.circular(5.0),
                      topRight: new Radius.circular(5.0)
                  ),
                  child:
                  Container(
                  height: 256.0,
                  child: SizedBox.expand(
                    
                        child: CachedNetworkImage(
                            placeholder:  (context, url) => Image.asset("images/imageplaceholder.png"),
                            imageUrl: widget.cardItem.imageUrl,
                            fit: BoxFit.cover,
                            height: 256.0)
                    
                  ),
                  )
            ),
            ListTile(
              title: new Text(widget.cardItem.title),
              subtitle: new Text(widget.cardItem.date),
            )
          ]),
        ));
  }
  Future<void> updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.cardItem.imageUrl),
      maximumColorCount: 5,
    );
    setState(() {});
    updateNewsFeedPostColor(paletteGenerator.lightVibrantColor?.color);
  }

  void updateNewsFeedPostColor(Color color) {
    databaseReferenceForUpdate
        .child(widget.cardItem.key)
        .update({'color': color.toString()});
  }
}

//   @override
//   Widget build(BuildContext context) {
    
// }
