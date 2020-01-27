import '../custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  CollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.animationController,
      this.isSelected = false,
      this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 50, end: 210).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 0, end: 10).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: widget.isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 8.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: Colors.grey[600],
                      offset: Offset(-2.0, -2.0),
                      blurRadius: 8.0,
                      spreadRadius: 1.0),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[700],
                      Colors.grey[600],
                      Colors.grey[500],
                      Colors.grey[200],
                    ],
                    stops: [
                      0,
                      0.1,
                      0.3,
                      1
                    ]))
            : BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[600],
                      offset: Offset(2.0, 2.0),
                      blurRadius: 8.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2.0, -2.0),
                      blurRadius: 8.0,
                      spreadRadius: 1.0),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[200],
                      Colors.grey[300],
                      Colors.grey[400],
                      Colors.grey[500],
                    ],
                    stops: [
                      0.1,
                      0.3,
                      0.8,
                      1
                    ]),
              ),
        //  BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(16.0)),
        //   color: widget.isSelected
        //       ? Colors.transparent.withOpacity(0.3)
        //       : Colors.transparent,
        // ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                color: widget.isSelected ? selectedColor : Colors.grey[700],
                size: 23.0,
              ),
              SizedBox(width: sizedBoxAnimation.value),
              (widthAnimation.value >= 190)
                  ? Text(widget.title,
                      style: widget.isSelected
                          ? listTitleSelectedTextStyle
                          : listTitleDefaultTextStyle)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
