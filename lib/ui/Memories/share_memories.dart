import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './day_memories.dart';
import './add_image.dart';

class ShareMemories extends StatefulWidget {
  @override
  _ShareMemoriesState createState() => _ShareMemoriesState();
}

class _ShareMemoriesState extends State<ShareMemories> {

  var _currentIndex = 0;
  final pageController = PageController();
  bool comingSoon;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForComingSoon;


  List TabViews = <Widget>[
    SendImageEntry(),
    DayMemories(dayNumber: 0),
    DayMemories(dayNumber: 1),
    DayMemories(dayNumber: 2),
    DayMemories(dayNumber: 3)
  ];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    comingSoon = null;
    _databaseReferenceForComingSoon = _database.reference().child("comingsoon");
    _databaseReferenceForComingSoon.onValue.listen(onComingSoonAdded);
    super.initState();
  }

  void onComingSoonAdded(Event event) {
    setState(() {
      comingSoon = event.snapshot.value["share-memory"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (comingSoon==null)?
    Center(child: Image.asset('loader')):
    (comingSoon == true)?
    Center(child: Image.asset('comingsoon'))
        :
    Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Share Your Memories'),
      ),
      body:
      PageView(
        children: TabViews,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
//      TabViews[_currentState],
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap:(int index){
              pageController.jumpToPage(index);
            },
            fixedColor: Theme.of(context).primaryColor,
            items:[
              BottomNavigationBarItem(
                  icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  title: Text("Share Image",)
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 0")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 1")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 2")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 3")
              )
            ],
          ),
        )
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
