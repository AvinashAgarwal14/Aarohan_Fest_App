import 'package:aavishkarapp/model/event.dart';
import 'package:flutter/material.dart';
import 'package:aavishkarapp/util/event_details.dart';
import '../search_by_tags/tags.dart';

class SearchTab extends StatefulWidget {
  final eventsList;
  const SearchTab({Key key, this.eventsList})
      : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<EventItem> feed;
  List<EventItem> filteredFeed;
  var searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    feed = widget.eventsList;
    filteredFeed = new List();

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

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchText.isNotEmpty) {
      List<EventItem> tempList = new List();
      for (int i = 0; i < feed.length; i++) {
        if (feed[i].title.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(feed[i]);
        }
      }
      setState(() {
        filteredFeed = tempList;
      });
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
                    child: SearchByTagsCards(eventCard: filteredFeed[position]));
              }),
          ) : Expanded(child:Center(child: Text('There is no such event!')))
        ],
      ),
    );
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }
}