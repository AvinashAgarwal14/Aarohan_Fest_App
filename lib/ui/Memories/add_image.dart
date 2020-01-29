import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/memory.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendImageEntry extends StatefulWidget {
  @override
  _SendImageEntryState createState() => _SendImageEntryState();
}

class _SendImageEntryState extends State<SendImageEntry> {
  File _image;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForMemories;
  bool upload;
  FirebaseUser currentUser;
  bool comingSoon;
  var dayNumber;
  var savedImageString;

  ScrollController scrollController;
  bool dialVisible = true;

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upload = false;
    _image = null;
    savedImageString = null;
    _getUser();
    loadSavedImage();
    _databaseReferenceForMemories =
        _database.reference().child("Memories/Day-0");
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });

//    comingSoon = true;
    dayNumber = 0;
    comingSoon = false;

//    var format = new DateFormat.yMd();
//    var dateString = format.format(DateTime.now()).split('/');
//    print(dateString);
//    var month = int.parse(dateString[0]);
//    var day = int.parse(dateString[1]);
//    if(month == 2 && day>=7 && day<=10) {
//      comingSoon = false;
//      if(day == 7)
//        dayNumber = 0;import 'dart:convert' as JSON;

//      if(day == 8)
//        dayNumber = 1;
//      if(day == 9)
//        dayNumber = 2;
//      if(day == 10)
//        dayNumber = 3;
//    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (comingSoon == false)
        ? (upload == false)
            ? Scaffold(
                body: Column(children: <Widget>[
                  Container(
                      height: 400.0,
                      child: (_image != null)
                          ? Image(image: FileImage(File(_image.path)))
                          : Image.asset('images/imageplaceholder.png')),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: (_image != null &&
                                  _image.path == savedImageString)
                              ? Text("Image Uploaded!")
                              : Text('Upload Image'),
                          onPressed: (_image != null &&
                                  _image.path != savedImageString)
                              ? uploadFile
                              : null,
                          color: Colors.cyan,
                        ),
                        SizedBox(width: 10.0),
                        RaisedButton(
                          child: Text('Clear Selection'),
                          onPressed: (_image != null) ? clearSelection : null,
                          color: Colors.red,
                        )
                      ]),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                          "Share your favourite Aarohan memory for Day - $dayNumber and get a chance to win Eurekoins!"),
                    ),
                  )
                ]),
                floatingActionButton: SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: dialVisible,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Options',
                  heroTag: 'options-hero-tag',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.camera_enhance),
                      backgroundColor: Colors.blue,
                      label: 'Camera',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: chooseFileCamera,
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.sd_storage),
                      backgroundColor: Colors.green,
                      label: 'Gallery',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: chooseFileGallery,
                    ),
                  ],
                ))
            : Center(child: CircularProgressIndicator())
        : Image.asset('images/imageplaceholder.png');
  }

  Future chooseFileCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 20)
        .then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future chooseFileGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 20)
        .then((image) {
      print(image);
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    setState(() {
      upload = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'Memories/Day-${dayNumber}/${currentUser.providerData[1].displayName}-${currentUser.providerData[1].email}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      var format = new DateFormat.yMd();
      var dateString = format.format(DateTime.now());
      MemoryItem newImage = new MemoryItem(
          currentUser.providerData[1].displayName, dateString, currentUser.providerData[1].email, fileURL);
      var bytes =
          utf8.encode("${currentUser.providerData[1].email}" + "${currentUser.providerData[1].displayName}");
      var encoded = sha1.convert(bytes);
      _databaseReferenceForMemories.child("$encoded").set(newImage.toJson());
    });
    setState(() {
      upload = false;
    });
    saveImage(_image.path);
    print('File Uploaded');
  }

  clearSelection() {
    setState(() {
      _image = null;
    });
  }

  Future _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  loadSavedImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedImageString = preferences.getString('savedImageString');
      _image = File(savedImageString);
    });
  }

  saveImage(value) async {
    setState(() {
      savedImageString = value;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('savedImageString', '$value');
  }
}
