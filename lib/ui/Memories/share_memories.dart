import 'package:flutter/material.dart';
import './day_memories.dart';
import './add_image.dart';

class ShareMemories extends StatefulWidget {
  @override
  _ShareMemoriesState createState() => _ShareMemoriesState();
}

class _ShareMemoriesState extends State<ShareMemories> {
  var _currentState = 0;
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Share Your Memories'),
      ),
      body: TabViews[_currentState],
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            currentIndex: _currentState,
            onTap:(int index){
              setState(() {
                _currentState = index;
              });
            },
            fixedColor: Theme.of(context).primaryColor,
            items:[
              BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                title: Text("Share Image",),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 0")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 1")
              ),BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 2")
              ),BottomNavigationBarItem(
                  icon: Icon(Icons.today, color: Theme.of(context).primaryColor),
                  title: Text("Day 3")
              )
            ],
          ),
        )
    );
  }
}
