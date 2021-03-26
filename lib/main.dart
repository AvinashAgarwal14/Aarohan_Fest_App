import 'package:arhn_app_2021/ui/arcade/HomePage.dart';
import 'package:arhn_app_2021/ui/dashboard/dashboard.dart';
import 'package:arhn_app_2021/ui/eurekoin/eurekoin_leaderboard.dart';
import 'package:arhn_app_2021/ui/eurekoin/eurekoin_loader.dart';
import 'package:arhn_app_2021/ui/interficio/interficio.dart';
import 'package:arhn_app_2021/ui/prelims/prelims.dart';
import 'package:arhn_app_2021/util/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import './ui/search_by_tags/tags.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurekoin/eurekoin.dart';
import './ui/contact_us/contact_us.dart';
import './ui/sponsors/sponsors.dart';
import './ui/contributors/contributors.dart';
import './ui/about_us/about_us.dart';
import 'package:arhn_app_2021/ui/Intro.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff121212),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light));

  WidgetsFlutterBinding.ensureInitialized();

  runApp(AavishkarApp());
}

class AavishkarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrapped within Dynamic Theme to change the theme
    // By toggling the change theme
    return MaterialApp(
      title: "Aarohan App",
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0xff03A062),
        primaryColor: Color(0xFF292D32),
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Color(0xff03A062),
        primaryColor: Color(0xFF292D32),
      ),
      initialRoute: "/splash",
      routes: <String, WidgetBuilder>{
        "/intro": (BuildContext context) => IntroScreen(),
        "/splash": (BuildContext context) => SplashScreen(),
        "/ui/dashboard": (BuildContext context) => Dashboard(),
        "/ui/prelims": (BuildContext context) => Prelims(),
        "/ui/tags": (BuildContext context) => SearchByTags(),
        "/ui/schedule": (BuildContext context) => Schedule(),
        "/ui/account/login": (BuildContext context) => LogInPage(),
        "/ui/scoreboard": (BuildContext context) => Scoreboard(),
        "/ui/eurekoin": (BuildContext context) => EurekoinLoader(),
        "/ui/sponsors/sponsors": (BuildContext context) => Sponsors(),
        "/ui/contact_us/contact_us": (BuildContext context) => ContactUs(),
        "/ui/contributors/contributors": (BuildContext context) =>
            Contributors(),
        "/ui/about_us/about_us": (BuildContext context) => AboutUsPage(),
        "ui/interficio": (BuildContext context) => MyApp(),
        "/ui/arcade_game": (BuildContext context) => Pacman(),
        "/eurekoin/leader_board": (BuildContext context) =>
            EurekoinLeaderBoard(),
        "/ui/comingsoon": (BuildContext context) => ComingSoon(),
      },
    );
  }
}
