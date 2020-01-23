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

class _DayMemoriesState extends State<DayMemories> {

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
    print(widget.dayNumber);
    _database.setPersistenceEnabled(true);
    _database.setPersistenceCacheSizeBytes(150000000);
    _databaseReferenceForMemories =
        _database.reference().child("Memories/Day-${widget.dayNumber}");
    _databaseReferenceForMemories.onChildAdded.listen(_onImageEntryAdded);
    _databaseReferenceForMemories.onChildChanged
        .listen(_onImageEntryUpdated);
    _databaseReferenceForMemories.onChildRemoved
        .listen(_onImageEntryRemoved);
  }

  @override
  Widget build(BuildContext context) {
    return (sharedImages.length !=0) ?
//    Scaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        centerTitle: true,
//        elevation: 0,
//        title: Text(
//          'Day - ${widget.dayNumber} Memories',
//          style: TextStyle(color: Colors.black),
//        ),
//        backgroundColor: Colors.transparent,
//        iconTheme: IconThemeData(color: Colors.black),
//      ),
//      body:
      StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 3,
        itemCount: sharedImages.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => showImageDialog(context, sharedImages[index]),
          child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image:
                CachedNetworkImageProvider(sharedImages[index].imageURL),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0)),
        )),
        staggeredTileBuilder: (index) => _staggeredTiles[index % _staggeredTiles.length],
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      )
//    )
    : Container();
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

  showImageDialog(BuildContext context, image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: image.imageURL,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(image.name),
                Text(image.email),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
