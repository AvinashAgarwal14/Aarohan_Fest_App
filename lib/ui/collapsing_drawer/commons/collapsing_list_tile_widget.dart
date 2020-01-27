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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color:  Colors.white,
                  boxShadow: [
                    BoxShadow(
                       color: Colors.grey[500],
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0),
                  ],
        ),
        //  BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(16.0)),
        //   color: widget.isSelected
        //       ? Colors.transparent.withOpacity(0.3)
        //       : Colors.transparent,
        // ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                color: widget.isSelected ? selectedColor : Colors.grey[700],
                size: 27.0,
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
