import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import '../../model/memory.dart';

class DayMemories extends StatefulWidget {
  final dayNumber;
  DayMemories({Key key, this.dayNumber}) : super(key: key);

  @override
  _DayMemoriesState createState() => _DayMemoriesState();
}

class _DayMemoriesState extends State<DayMemories>
//    with AutomaticKeepAliveClientMixin<DayMemories>
{
  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1)
  ];

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForMemories;
  DatabaseReference _databaseReferenceForComingSoon;
  bool showDay;
  List<MemoryItem> sharedImages;

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
    sharedImages = new List();
    showDay == null;
//    _database.setPersistenceEnabled(true);
//    _database.setPersistenceCacheSizeBytes(150000000);
    _databaseReferenceForMemories =
        _database.reference().child("Memories/Day-${widget.dayNumber}");
    _databaseReferenceForMemories.onChildAdded.listen(_onImageEntryAdded);
    _databaseReferenceForMemories.onChildChanged.listen(_onImageEntryUpdated);
    _databaseReferenceForMemories.onChildRemoved.listen(_onImageEntryRemoved);

    _databaseReferenceForComingSoon = _database.reference().child("comingsoon");
    _databaseReferenceForComingSoon.onValue.listen(onComingSoonAdded);

    print(widget.dayNumber);
  }

  @override
  Widget build(BuildContext context) {
    return (showDay != null)
        ? (showDay == true)
            ? (sharedImages.length != 0)
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    child: CustomScrollView(
                      cacheExtent: MediaQuery.of(context).size.height * 3,
                      slivers: <Widget>[
                        new SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 3,
                          itemCount: sharedImages.length,
                          itemBuilder: (context, index) => GestureDetector(
                              child: new ClipRRect(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(10.0)),
                                child: CachedNetworkImage(
                                    placeholder: (context, url) => Image.asset(
                                        "images/imageplaceholder.png"),
                                    imageUrl: sharedImages[index].imageURL,
                                    fit: BoxFit.cover),
                              ),
                              onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Scaffold(
                                        body: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            "images/imageplaceholder.png"),
                                                    imageUrl:
                                                        sharedImages[index]
                                                            .imageURL,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  sharedImages[index].name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 21),
                                                ),
                                                Text(
                                                  sharedImages[index].email,
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 13),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    IconButton(
                                                      color: Colors.black,
                                                      icon: Icon(Icons.close),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              //  Navigator.of(context).push(
                              //   new MaterialPageRoute(
                              //       fullscreenDialog: true,
                              //       builder: (BuildContext context) {
                              //         return Scaffold(
                              //           body: Column(
                              //             children: <Widget>[
                              //               Expanded(
                              //                 child: Container(
                              //                   width: double.infinity,
                              //                   child: CachedNetworkImage(
                              //                       placeholder: (context, url) =>
                              //                           Image.asset(
                              //                               "images/imageplaceholder.png"),
                              //                       imageUrl: sharedImages[index]
                              //                           .imageURL,
                              //                       fit: BoxFit.contain),
                              //                 ),
                              //               ),
                              //               Column(
                              //                 children: <Widget>[
                              //                   Text(
                              //                     sharedImages[index].name,
                              //                     style: TextStyle(
                              //                         fontWeight: FontWeight.bold,
                              //                         fontSize: 21),
                              //                   ),
                              //                   Text(
                              //                     sharedImages[index].email,
                              //                     style: TextStyle(
                              //                         fontStyle: FontStyle.italic,
                              //                         fontSize: 13),
                              //                   ),
                              //                   Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.center,
                              //                     children: <Widget>[
                              //                       IconButton(
                              //                         color: Colors.black,
                              //                         icon: Icon(Icons.close),
                              //                         onPressed: () =>
                              //                             Navigator.pop(context),
                              //                       )
                              //                     ],
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //         );
                              //       }),
                              // ),
                              ),
                          staggeredTileBuilder: (index) =>
                              _staggeredTiles[index % _staggeredTiles.length],
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                      ],
                    ),
                  )
                : Container()
            : Image.asset('images/imageplaceholder.png')
        : Center(child: CircularProgressIndicator());
  }

  void _onImageEntryAdded(Event event) {
    setState(() {
      sharedImages.add(MemoryItem.fromSnapshot(event.snapshot));
    });
  }

  void _onImageEntryUpdated(Event event) {
    var oldEntry = sharedImages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      sharedImages[sharedImages.indexOf(oldEntry)] =
          MemoryItem.fromSnapshot(event.snapshot);
    });
  }

  void _onImageEntryRemoved(Event event) {
    var oldEntry = sharedImages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      sharedImages.removeAt(sharedImages.indexOf(oldEntry));
    });
  }

  showImageDialog(BuildContext context, image) {}

  void onComingSoonAdded(Event event) {
    setState(() {
      showDay = !event.snapshot.value["day-${widget.dayNumber}"];
    });
  }
}
