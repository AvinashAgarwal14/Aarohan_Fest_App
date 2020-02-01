import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/event_details.dart';
import '../../model/event.dart';
import 'package:firebase_database/firebase_database.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = new List();
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class DashBoardLayout extends StatefulWidget {
  @override
  _DashBoardLayoutState createState() => _DashBoardLayoutState();
}

class _DashBoardLayoutState extends State<DashBoardLayout> {
  CarouselSlider instance;
  int j = 0;
  double maxWidth = 180;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  List carouselImageList;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<EventItem>> eventsByCategories;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ScrollController _scrollController;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Color(0xFF6B872B),
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarIconBrightness: Brightness.dark));

    super.initState();
    _scrollController = ScrollController();
    eventsByCategories = {
      'All': new List(),
      'On-site': new List(),
      'Online': new List(),
      'Workshops': new List(),
      'Games': new List(),
      'Workshops and Special Attractions': new List(),
      'Talk': new List()
    };

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(150000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  nextSlider() {
    instance.nextPage(
        duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  prevSlider() {
    instance.previousPage(
        duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    if (eventsByCategories["Online"].length != 0 &&
        eventsByCategories["On-site"].length != 0 &&
        eventsByCategories["Workshops"].length != 0 &&
        eventsByCategories["Games"].length != 0 &&
        eventsByCategories["Workshops and Special Attractions"].length != 0 &&
        eventsByCategories["Talk"].length != 0 &&
        eventsByCategories["All"].length >= 35) {
      carouselImageList = List(eventsByCategories["All"].length);
      return Stack(
        children: <Widget>[
          ListView(
            cacheExtent: MediaQuery.of(context).size.height * 2,
            children: <Widget>[
              //TODO Trending
              Container(
                color: Colors.red,
                // padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: new EdgeInsets.symmetric(vertical: 0.0),
                        child: instance),
                    new Container(
                      height: 340,
                      color: Colors.white,
                      child: CarouselSlider(
                        height: 250.0,
                        //TODO add the upcoming events as per the date
                        items: map<Widget>(
                          carouselImageList,
                          (index, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                          item: eventsByCategories["All"]
                                              [index])),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[800],
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
                                    margin: new EdgeInsets.all(10.0),
                                    child: new ClipRRect(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(10.0)),
                                      child: new Stack(
                                        children: <Widget>[

                                          CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "images/imageplaceholder.png"),
                                              imageUrl:
                                                  // 'https://blog.socedo.com/wp-content/uploads/2016/09/Events.jpg',

                                               eventsByCategories["All"]
                                                       [index]
                                                   .imageUrl,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Positioned(
                                    bottom: 0.0,
                                    left: 30.0,
                                    right: 30.0,
                                    child: Container(
                                      height: 100.0,
                                      width: 200.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[800],
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
                                      margin: new EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              child: Text(
                                                  eventsByCategories["All"]
                                                          [index]
                                                      .title,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ))),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 10),
                                            child: Text(
                                              eventsByCategories["All"][index]
                                                      .body
                                                      .substring(0, 50) +
                                                  " ...",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                        autoPlay: true,
                        viewportFraction: 0.85,
                        aspectRatio: 16 / 9,
                        pauseAutoPlayOnTouch: Duration(seconds: 2),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/ui/eurekoin");
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Eurekoin Wallet",
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xFF6B872B),
                                //     Color(0xFF4B5E1D),
                                //     // Color(0xFF4AC5F1),
                                //     // Color(0xFF6B8BD8)
                                //   ],
                                //   stops: [0.3, 1],
                                // ),
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[700],
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-3.0, -3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed("/ui/eurekoin_casino");
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.casino,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Eurekoin Casino",
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // gradient: LinearGradient(
                                  //   colors: [
                                  //     Color(0xFF6B872B),
                                  //     Color(0xFF4B5E1D),
                                  //   ],
                                  //   stops: [0.3, 1],
                                  // ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[700],
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 7.0,
                                        spreadRadius: 1.0),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-3.0, -3.0),
                                        blurRadius: 7.0,
                                        spreadRadius: 1.0),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed("/interficio/interficio.dart");
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Journo Detective",
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // gradient: LinearGradient(
                                  //   colors: [
                                  //     Color(0xFF6B872B),
                                  //     Color(0xFF4B5E1D),
                                  //   ],
                                  //   stops: [0.3, 1],
                                  // ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[700],
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 7.0,
                                        spreadRadius: 1.0),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-3.0, -3.0),
                                        blurRadius: 7.0,
                                        spreadRadius: 1.0),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed("/ui/share_memories");
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.linked_camera,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Share Memories",
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color(0xFF6B872B),
                                //     Color(0xFF4B5E1D),
                                //   ],
                                //   stops: [0.3, 1],
                                // ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[700],
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-3.0, -3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              //TODO Online Events
              Container(
                color: Colors.white,
                // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        "Online Events",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          // shadows: [
                          //   BoxShadow(
                          //       color: Colors.grey[800],
                          //       offset: Offset(2.0, 2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          //   BoxShadow(
                          //       color: Colors.white,
                          //       offset: Offset(-2.0, -2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          // ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      height: 250.0,
                      // width: MediaQuery.of(context).size.width-10.0,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        cacheExtent: 1350.0,
                        itemCount: eventsByCategories["Online"].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventDetails(
                                        item: eventsByCategories["Online"]
                                            [index])),
                              );
                            },
                            child: Container(
                              height: 100.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[800],
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-3.0, -3.0),
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0),
                                ],
                              ),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: 150.0,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),

                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "images/imageplaceholder.png"),
                                              imageUrl:
                                                  eventsByCategories["Online"]
                                                          [index]
                                                      .imageUrl,

//                                                'https://www.hcsa.org.sg/wp-content/uploads/2018/10/181015-HCSA-Res-03-Events-banner.jpg',
                                                  // 'https://blog.socedo.com/wp-content/uploads/2016/09/Events.jpg',
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Text(
                                      eventsByCategories["Online"][index].title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //TODO Workshop And Games
              Container(
                color: Colors.white,
                //color: Colors.grey.shade200,
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Text(
                        "Workshops and Special Attractions ",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          // shadows: [
                          //   BoxShadow(
                          //       color: Colors.grey[800],
                          //       offset: Offset(1.0, 1.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          //   BoxShadow(
                          //       color: Colors.white,
                          //       offset: Offset(-1.0, -1.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          // ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      height: 250.0,
                      width: MediaQuery.of(context).size.width,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                          item: eventsByCategories[
                                                  "Workshops and Special Attractions"]
                                              [index])),
                                );
                              },
                              child: new Container(
                                padding: EdgeInsets.only(bottom: 25.0),
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[800],
                                              offset: Offset(4.0, 4.0),
                                              blurRadius: 10.0,
                                              spreadRadius: 1.0),
                                          BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-4.0, -4.0),
                                              blurRadius: 10.0,
                                              spreadRadius: 1.0),
                                        ],
                                      ),
                                      child: new ClipRRect(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(5.0)),


                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "images/imageplaceholder.png"),
                                              imageUrl:
                                                  // 'https://blog.socedo.com/wp-content/uploads/2016/09/Events.jpg',
                                              eventsByCategories[
                                                          "Workshops and Special Attractions"]
                                                      [index]
                                                  .imageUrl,

                                              fit: BoxFit.cover)),
                                      height: 150.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: Text(
                                        eventsByCategories[
                                                    "Workshops and Special Attractions"]
                                                [index]
                                            .title,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                          // shadows: [
                                          //   BoxShadow(
                                          //       color: Colors.grey[800],
                                          //       offset: Offset(4.0, 4.0),
                                          //       blurRadius: 10.0,
                                          //       spreadRadius: 1.0),
                                          //   BoxShadow(
                                          //       color: Colors.white,
                                          //       offset: Offset(-4.0, -4.0),
                                          //       blurRadius: 10.0,
                                          //       spreadRadius: 1.0),
                                          // ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        },
                        itemCount: eventsByCategories[
                                "Workshops and Special Attractions"]
                            .length,
                        viewportFraction: 0.6,
                        scale: 0.9,
                        // pagination: new SwiperPagination(
                        //     margin: new EdgeInsets.all(5.0),
                        //     builder: SwiperPagination.dots),
                      ),
                    ),
                  ],
                ),
              ),
              //TODO On-Site Events
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        "On-site Events ",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          // shadows: [
                          //   BoxShadow(
                          //       color: Colors.grey[800],
                          //       offset: Offset(2.0, 2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          //   BoxShadow(
                          //       color: Colors.white,
                          //       offset: Offset(-2.0, -2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          // ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      height: 250.0,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          cacheExtent: 4000.0,
                          itemCount: eventsByCategories["On-site"].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                            item: eventsByCategories["On-site"]
                                                [index])),
                                  );
                                },
                                child: Container(
                                  height: 150.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[800],
                                          offset: Offset(3.0, 3.0),
                                          blurRadius: 7.0,
                                          spreadRadius: 1.0),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-3.0, -3.0),
                                          blurRadius: 7.0,
                                          spreadRadius: 1.0),
                                    ],
                                  ),
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          height: 150.0,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),

                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          "images/imageplaceholder.png"),
                                                  imageUrl:
                                                      // 'https://blog.socedo.com/wp-content/uploads/2016/09/Events.jpg',
                                                  eventsByCategories[
                                                         "On-site"][index]
                                                     .imageUrl,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover))),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: Text(
                                            eventsByCategories["On-site"][index]
                                                .title,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ))
                                    ],
                                  ),
                                ));
                          }),
                    )
                  ],
                ),
              ),
              // TODO Talk
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        "Tech Talks ",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          // shadows: [
                          //   BoxShadow(
                          //       color: Colors.grey[800],
                          //       offset: Offset(2.0, 2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          //   BoxShadow(
                          //       color: Colors.white,
                          //       offset: Offset(-2.0, -2.0),
                          //       blurRadius: 10.0,
                          //       spreadRadius: 1.0),
                          // ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 5.0,
                      ),
                      height: 250.0,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          cacheExtent: 4000.0,
                          itemCount: eventsByCategories["Talk"].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                            item: eventsByCategories["Talk"]
                                                [index])),
                                  );
                                },
                                child: Container(
                                  height: 150.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[800],
                                          offset: Offset(3.0, 3.0),
                                          blurRadius: 7.0,
                                          spreadRadius: 1.0),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-3.0, -3.0),
                                          blurRadius: 7.0,
                                          spreadRadius: 1.0),
                                    ],
                                  ),
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          height: 150.0,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          "images/imageplaceholder.png"),
                                                  imageUrl:
                                                      // 'https://blog.socedo.com/wp-content/uploads/2016/09/Events.jpg',
                                                   eventsByCategories["Talk"]
                                                           [index]
                                                       .imageUrl,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: Text(
                                          eventsByCategories["Talk"][index]
                                              .title,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(height: 65.0),
            ],
          ),
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/gifs/loaderlight.gif"),
                fit: BoxFit.fill)),
      );
    }
  }

  void _onEntryAdded(Event event) {
    setState(() {
      eventsByCategories["All"].add(EventItem.fromSnapshot(event.snapshot));
      eventsByCategories[event.snapshot.value["category"]]
          .add(EventItem.fromSnapshot(event.snapshot));
      if (event.snapshot.value["category"] == "Workshops" ||
          event.snapshot.value["category"] == "Games") {
        eventsByCategories["Workshops and Special Attractions"]
            .add(EventItem.fromSnapshot(event.snapshot));
      }
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = eventsByCategories[event.snapshot.value["category"]]
        .singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByCategories[event.snapshot.value["category"]][
          eventsByCategories[event.snapshot.value["category"]]
              .indexOf(oldEntry)] = EventItem.fromSnapshot(event.snapshot);
    });
  }
}
