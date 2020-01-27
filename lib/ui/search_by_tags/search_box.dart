import 'package:aavishkarapp/model/event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aavishkarapp/util/event_details.dart';

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
                    child: EventCard(cardItem: filteredFeed[position]));
              }),
          ) : Expanded(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final cardItem;

  EventCard({this.cardItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                          item: cardItem)),
                                );
      },
    child: Card(
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
                    child: Hero(
                        tag: cardItem.title,
                        child: CachedNetworkImage(
                            placeholder:  (context, url) => Image.asset("images/imageplaceholder.png"),
                            imageUrl: cardItem.imageUrl,
                            fit: BoxFit.cover,
                            height: 256.0)
                    ),
                  ),
                  )
            ),
            ListTile(
              title: new Text(cardItem.title),
              subtitle: new Text(cardItem.date),
            )
          ]),
        ));
  }
}
