import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/drawer.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
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
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

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
        drawer: NavigationDrawer(),
        // appBar: AppBar(
        //   elevation: 0,
        //   title: Text("About Aavishkar"),
        // ),

        body: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              image: DecorationImage(
                  image: AssetImage("images/AboutUs.png"), fit: BoxFit.fill)),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  key: listViewKey,
                  controller: scrollController,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(50.0, 10.0, 30.0, 0.0),
                      child: Text(
                        "About Aarohan",
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                      child: new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: new Image.asset("assets/AU1.png")),
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
                          ' Early morning classes, assignments, surprise tests, semesters, interviews. In short a typical mundane college routine. Amidst this monotonous and draining lifestyle, we all forget to discover that tiny flicker of alacrity to do what we love. This Aarohan, we bring to you a unique opportunity to rediscover that spark, to reignite that flicker and to unearth the inner “you” ! Aarohan, over the past decade years has grown at an exorbitant rate, from being a humble platform for students to get together and show case their skills to one of Eastern India\'s largest techno management fests, witnessing participation from across the country. "Teamwork is the ability to work together toward a common vision." With a bid to make Aarohan scale greater heights, the five biggest techno management clubs of NIT Durgapur, have come together as Team Aavishkar, the core organising team of Aarohan 2020. With over 200 committee members, we promise that this Aarohan will be bigger than ever before.',
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
                                    "assets/AU2.png",
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
                                    ' Aarohan 2020 presents before you some unique opportunities to prove yourselves on a global scale, with its series of flagship events. We provide you with you with an opportunity to prove your mettle and compete with the best with our hardware and software hackathons and CodeCracker. Solve mind boggling puzzles in Transmission or unravel murder mysteries in Call Out Sherlock. Are you Engineer Enough?   Put your frugal innovation (read \'jugaad\') skills and aptitude  to test with Junkyard, Constructo and Invictus. Finally for all the future scientists and innovators out there, TechMela is your platform to portray what you are capable of. Never knew you could gain so much at a fest? Aarohan is the place you would love to be.',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),
                      ),
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
                                  "assets/AU3.png",
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
                                  ' For those who believe that weekends are just for lazy people who prefer no work and all play, you were right. Jack will never be a dull boy because he would know how to have fun the right way. Team Aavishkar is ecstatic to announce a plethora of special attractions and fun activities during Aarohan 2020. From gaming zones to stand up comedy nights we have it all covered. Laser shows, music and dance performances, army vehicles display and cycle stunts shall add to the resplendence of the occasion. Well to add to that, we have our own virtual currency which you can exchange for exciting goodies! We also proudly present our flagship talk shows - Inspiratie and Ignitia, a platform which invites inspirational personalities from all walks of life to share their experiences and motivate us to be better each day. Get ready for the most happening four days of your college life.',
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
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    child: new Image.asset("assets/AU4.png",
                                        fit: BoxFit.fill)),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    " The theme for Aarohan 2020 is \"Advancements in Defense Technologies\", with the idea of bringing to the fore, the breathtaking progress made in the field. Be it the Agni V's or the Rafale's, these advancements have gone a long way in ensuring our safety. The mascot for Aarohan 2020 is Avani, inspired by Avani Chaturvedi, the first Indian woman to fly a MiG -21 Bison solo. another inspirational story which forms the spirit and vision behind Aarohan 2020.",
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
                FloatingActionButton(
                  elevation: 0,
                  foregroundColor: Color(0xFF233327),
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(Icons.menu),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
