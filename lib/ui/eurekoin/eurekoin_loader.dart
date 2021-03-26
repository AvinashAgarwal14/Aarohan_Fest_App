import 'package:arhn_app_2021/ui/eurekoin/eurekoin.dart';
import 'package:flutter/material.dart';

class EurekoinLoader extends StatefulWidget {
  @override
  _EurekoinLoaderState createState() => _EurekoinLoaderState();
}

class _EurekoinLoaderState extends State<EurekoinLoader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return EurekoinHomePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/coin.gif'),
      )),
    );
  }
}
