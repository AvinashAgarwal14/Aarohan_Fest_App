// import 'package:arhn_app_2021/ui/arcade/arcade_game.dart';
// import 'package:arhn_app_2021/ui/arcade/game_controller.dart';
import 'package:arhn_app_2021/ui/arcade/HomePage.dart';
import 'package:arhn_app_2021/ui/dashboard/dashboard.dart';
import 'package:arhn_app_2021/ui/eurekoin/eurekoin_leaderboard.dart';
// import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './ui/search_by_tags/tags.dart';
import './ui/Memories/share_memories.dart';
//import './ui/maps/map.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurekoin/eurekoin.dart';
import './ui/contact_us/contact_us.dart';
import './ui/sponsors/sponsors.dart';
import './ui/contributors/contributors.dart';
import './ui/about_us/about_us.dart';
import './ui/interficio/interficio.dart';
import './ui/games/home_page.dart';
// import 'package:flame/flame.dart';
import 'package:arhn_app_2021/ui/Intro.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff121212),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light));

  WidgetsFlutterBinding.ensureInitialized();
  // Util flameUtil = Util();
  // // await flameUtil.fullScreen();
  // await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  // Flame.images.loadAll([
  //   "GameBG.png",
  //   "player.png",
  //   "bomb1Green.png",
  //   "bomb1Red.png",
  //   "bomb2Green.png",
  //   "bomb2Red.png",
  // ]);
  intro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('boolValue');
    return boolValue;
  }

  intro_bool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', true);
  }

  SharedPreferences storage = await SharedPreferences.getInstance();
  // GameController gameController = GameController(storage);

  // TapGestureRecognizer tapper = TapGestureRecognizer();
  // tapper.onTapDown = gameController.onTapDown;
  // flameUtil.addGestureRecognizer(tapper);

  runApp(Aavishkar_App(/*gameController*/));
}

class Aavishkar_App extends StatelessWidget {
  // GameController gameController;
  // Aavishkar_App(this.gameController);
  @override
  Widget build(BuildContext context) {
    // Wrapped within Dynamic Theme to change the theme
    // By toggling the change theme

    return MaterialApp(
      title: "Aarohan App",
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff03A062),
      ),
      initialRoute: "/splash",
      routes: <String, WidgetBuilder>{
        "/intro": (BuildContext context) => IntroScreen(),
        "/splash": (BuildContext context) => SplashScreen(),
        "/ui/dashboard": (BuildContext context) => Dashboard(),
        "/ui/tags": (BuildContext context) => SearchByTags(),
        "/ui/schedule": (BuildContext context) => Schedule(),
        "/ui/account/login": (BuildContext context) => LogInPage(),
//            "/ui/maps/map": (BuildContext context) => MapPage(),
        "/ui/scoreboard": (BuildContext context) => Scoreboard(),
        "/ui/eurekoin": (BuildContext context) => EurekoinHomePage(),
        "/ui/eurekoin_casino": (BuildContext context) => HomePage(),
        "/ui/share_memories": (BuildContext context) => ShareMemories(),
        "/ui/sponsors/sponsors": (BuildContext context) => Sponsors(),
        "/ui/contact_us/contact_us": (BuildContext context) => ContactUs(),
        "/ui/contributors/contributors": (BuildContext context) =>
            Contributors(),
        "/ui/about_us/about_us": (BuildContext context) => AboutUsPage(),
        "/interficio/interficio.dart": (BuildContext context) => MyApp(),
        "/ui/arcade_game": (BuildContext context) => Pacman(),
        "/eurekoin/leader_board": (BuildContext context) => EurekoinLeaderBoard(),
      },
    );
  }
}
