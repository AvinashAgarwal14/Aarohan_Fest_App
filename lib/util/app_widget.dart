
/*import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppCard extends StatelessWidget {

  Widget child;

  AppCard({this.child});

 
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Neumorphic(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 9.0, horizontal: 15.0),
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                              BorderRadius.circular(12.0),
                                            ),
                                            depth: 8.0,
                                            intensity: 1.0,
                                            lightSource: LightSource.top,
                                            shadowLightColor: Colors.grey[700]
                                                .withOpacity(0.55),
                                            shadowDarkColor: Colors.black,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF292D32),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            height: 100.0,
                                            // width: MediaQuery.of(context).size.width * 0.7,
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Neumorphic(
                                                  style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    boxShape: NeumorphicBoxShape
                                                        .roundRect(
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                    ),
                                                    depth: 8.0,
                                                    intensity: 0.7,
                                                    lightSource:
                                                        LightSource.top,
                                                    shadowLightColor: Colors
                                                        .grey[700]
                                                        .withOpacity(0.7),
                                                    shadowDarkColor: Colors
                                                        .black
                                                        .withOpacity(0.9),
                                                  ),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.28,
                                                    child: Hero(
                                                      tag: showEvents[index]
                                                          .title,
                                                      child: CachedNetworkImage(
                                                        height: 100,
                                                        width: 120,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          print(
                                                              "Could not load content");
                                                          return Image.asset(
                                                              "images/imageplaceholder.png");
                                                        },
                                                        placeholder: (context,
                                                                url) =>
                                                            Image.asset(
                                                                "images/imageplaceholder.png"),
                                                        imageUrl:
                                                            showEvents[index]
                                                                .imageUrl,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                      // border: Border.all(
                                                      //   style:
                                                      //       BorderStyle.solid,
                                                      //   width: 1.5,
                                                      //   color: Color(0xFF63d471)
                                                      //       .withOpacity(0.5),
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                               
                                        );
  }
}*/