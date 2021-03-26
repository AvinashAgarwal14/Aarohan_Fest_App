import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/comingsoon.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 15.0,
            left: 15.0,
            child: NeumorphicButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.all(0),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
                depth: 7.5,
                intensity: 1.0,
                lightSource: LightSource.topLeft,
                shadowLightColor: Colors.grey[700].withOpacity(0.6),
                shadowDarkColor: Colors.black,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF63d471).withOpacity(0.5),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF396b4b),
                      Color(0xFF78e08f),
                    ],
                  ),
                ),
                height: 50.0,
                width: 50.0,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    // size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
