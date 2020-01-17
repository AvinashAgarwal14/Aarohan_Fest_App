import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final eventsList;
  SearchBox({Key key, this.eventsList}) : super(key: key);
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {


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
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
