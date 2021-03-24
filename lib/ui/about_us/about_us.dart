import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/drawer2.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;
  var listViewKey = new GlobalKey();
  var scrollController = new ScrollController();

  var animatedBoxOneKey = new GlobalKey();
  AnimationController animatedBoxOneEnterAnimationController;

  var animatedBoxTwoKey = new GlobalKey();
  AnimationController animatedBoxTwoEnterAnimationController;

  var animatedBoxThreeKey = new GlobalKey();
  AnimationController animatedBoxThreeEnterAnimationController;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    animatedBoxOneEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animatedBoxTwoEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animatedBoxThreeEnterAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    scrollController.addListener(() {
      _updateAnimatedBoxOneEnterAnimation();
      _updateAnimatedBoxTwoEnterAnimation();
      _updateAnimatedBoxThreeEnterAnimation();
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  static const enterAnimationMinHeight = 100.0;

  _updateAnimatedBoxOneEnterAnimation() {
    if (animatedBoxOneEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxOneKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxOneEnterAnimationController.forward();
    }
  }

  _updateAnimatedBoxTwoEnterAnimation() {
    if (animatedBoxTwoEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxTwoKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxTwoEnterAnimationController.forward();
    }
  }

  _updateAnimatedBoxThreeEnterAnimation() {
    if (animatedBoxThreeEnterAnimationController.status !=
        AnimationStatus.dismissed) {
      return; // animation already in progress/finished
    }
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject animatedBoxObject =
        animatedBoxThreeKey.currentContext?.findRenderObject();
    if (listViewObject == null || animatedBoxObject == null) return;
    final listViewHeight = listViewObject.paintBounds.height;
    final animatedObjectTop =
        animatedBoxObject.getTransformTo(listViewObject).getTranslation().y;
    final animatedBoxVisible =
        (animatedObjectTop + enterAnimationMinHeight < listViewHeight);
    if (animatedBoxVisible) {
      // start animation
      animatedBoxThreeEnterAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxOpacityOne = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxOneEnterAnimationController);
    final boxPositionOne = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxOneEnterAnimationController);

    final boxOpacityTwo = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxTwoEnterAnimationController);
    final boxPositionTwo = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxTwoEnterAnimationController);

    final boxOpacityThree = CurveTween(curve: Curves.easeOut)
        .animate(animatedBoxThreeEnterAnimationController);
    final boxPositionThree = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animatedBoxThreeEnterAnimationController);

    return WillPopScope(
      onWillPop: () {
        // SystemChrome.setSystemUIOverlayStyle(
        //   SystemUiOverlayStyle(
        //       statusBarColor: Colors.white,
        //       systemNavigationBarIconBrightness: Brightness.dark),
        // );
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavigationDrawer("${ModalRoute.of(context).settings.name}"),
        // appBar: AppBar(
        //   elevation: 0,
        //   title: Text("About Aavishkar"),
        // ),

        body: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              image: DecorationImage(
                  image: AssetImage("images/AboutUs.gif"), fit: BoxFit.fill)),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  key: listViewKey,
                  controller: scrollController,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(90.0, 20.0, 30.0, 0.0),
                      child: Text(
                        "About Aarohan",
                        style: GoogleFonts.josefinSans(
                            fontSize: 30, color: Colors.white //(0xFF6B872B),
                            ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                      child: new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: new Image.asset("assets/1096.png")),
                    ),
                    new Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 23.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "The world, has changed. From early morning rush hours, and physical classes to, waking up and logging in, life has become stationary. Dull even. And the sentiment to break free is stronger than ever before. But many a people have side-lined this new online reality as a thing born out of necessity. They refuse to see the sheer potential this holds for all of us. Most don't, but not us.",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    new FadeTransition(
                      opacity: boxOpacityOne,
                      child: new SlideTransition(
                        position: boxPositionOne,
                        child: new Container(
                            key: animatedBoxOneKey,
//                  height: 750.0,
                            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                new ClipRRect(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  child: new Image.asset(
                                    "assets/aaraap2.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "We, we were intrigued. The idea of building a virtual reality for everyone to take joy in, it fascinated us. And with that, we decided to weave our reality. 2021 is a year of possibilities. And it is time Team Aavishkar rose to the occasion. To build it's own matrix. Of events. Fun. Knowledge. And innovation. To re-think and re-invent Aarohan.",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    new FadeTransition(
                      opacity: boxOpacityTwo,
                      child: new SlideTransition(
                        position: boxPositionTwo,
                        child: new Container(
                          key: animatedBoxTwoKey,
//                  height: 500.0,
                          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                          child: Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: new Image.asset(
                                  "assets/brain.png",
                                  // fit: BoxFit.fill,
                                  height: 300.0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Aarohan'21 is here. Virtual. Bigger. Better. Each event has been hand crafted to provide you the best of this virtual world. So be it breaching systems and exploring the web in FooBar CTF, ideating and showcasing your talent in TechMela, going on a wild treasure hunt across the web in Rechase, develop ecologically sustainable products in Junkyard, building solutions from the ground up in Hackoverflow, or unraveling mysteries in Call Out Sherlock and Journo Detective, Aarohan'21 has everything. ",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    new FadeTransition(
                      opacity: boxOpacityThree,
                      child: new SlideTransition(
                        position: boxPositionThree,
                        child: new Container(
                            key: animatedBoxThreeKey,
//                  height: 700.0,
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                new ClipRRect(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  child: new Image.asset(
                                    "assets/img_6948_polarr.png",
                                    // fit: BoxFit.fill,
                                    height: 300.0,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "And this is just the beginning. Gaming. Stand-up nights. Talk shows like Ignitia and Inspiratie, Aarohan'21 has all you could dream of, and much more. So take a deep breath, and brace yourself. It is time to delve into this matrix of possibilities, dreams and aspirations. Ascend with Aarohan. The Matrix is Everywhere.",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: new FlatButton(
                          onPressed: () {
                            scrollController.jumpTo(0.0);
                            animatedBoxOneEnterAnimationController.reset();
                            animatedBoxTwoEnterAnimationController.reset();
                            animatedBoxThreeEnterAnimationController.reset();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "Move Up",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              new Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              )
                            ],
                          )),
                    )
                  ],
                ),
                menuButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuButton() {
    return NeumorphicButton(
      onPressed: () {
        _scaffoldKey.currentState.openDrawer();
        //  Navigator.of(context).pop();
      },
      margin: EdgeInsets.all(10),
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
            Icons.menu,
            color: Colors.white,
            // size: 25,
          ),
        ),
      ),
    );
  }
}
