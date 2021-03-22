import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppCard extends StatelessWidget {

  final Widget child;

  AppCard({this.child});

 
  @override
  Widget build(BuildContext context) {
    Neumorphic(
        margin: EdgeInsets.symmetric(horizontal: 10),
        style: NeumorphicStyle(
          color: Color(0xFF292D32),
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12.0),
          ),
          depth: 5,
          intensity: 1,
          lightSource: LightSource.topLeft,
          shadowLightColor: Colors.grey[700].withOpacity(0.5),
          shadowDarkColor: Colors.black,
        ),
        child: child
      );
  }

}
