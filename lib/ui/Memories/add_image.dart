import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import '../../model/memory.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SendImageEntry extends StatefulWidget {
  @override
  _SendImageEntryState createState() => _SendImageEntryState();
}

class _SendImageEntryState extends State<SendImageEntry> {
  File _image;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForMemories;
  bool upload = false;
  FirebaseUser currentUser;

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
    _getUser();
    _image = null;
    _databaseReferenceForMemories =
        _database.reference().child("Memories/Day-0");
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (upload == false)?  Scaffold(
        body: Column(children: <Widget>[
          Container(
              height: 300.0,
              child: (_image != null)
                  ? Image(image: FileImage(File(_image.path)))
                  : Image.asset('images/imageplaceholder.png')),
          _image != null
              ? RaisedButton(
                  child: Text('Upload File'),
                  onPressed: uploadFile,
                  color: Colors.cyan,
                )
              : Container(),
          _image != null
              ? RaisedButton(
                  child: Text('Clear Selection'),
                  onPressed: clearSelection,
                )
              : Container(),
          Center(
            child: Text("Share your favourite Aarohan memory and get a chance to win Eurekoins!"),
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
        )) : Center(child: CircularProgressIndicator());
  }

  Future chooseFileCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 60).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future chooseFileGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 60).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    setState(() {
      upload = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Memories/Day-0/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      var newRef = _databaseReferenceForMemories.push();
      MemoryItem newImage =
          new MemoryItem(currentUser.displayName, currentUser.displayName, currentUser.email, fileURL);
      newRef.set(newImage.toJson());
    });
    setState(() {
      upload = false;
    });
  }

  clearSelection() {
    setState(() {
      _image = null;
    });
  }

  Future _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
  }
}
