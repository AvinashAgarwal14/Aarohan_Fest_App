import 'dart:async';

import 'package:flutter/material.dart';

class DashboardLoader extends StatefulWidget {
  @override
  _DashboardLoaderState createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushNamed("/ui/dashboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('images/gifs/X1D_lossy.gif'),
      )),
    );
  }
}
