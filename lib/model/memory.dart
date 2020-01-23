import 'package:firebase_database/firebase_database.dart';

// A class where each Event is treated like an object
// For simple usage and retrieval of data from FireBase
class MemoryItem {

  MemoryItem(
      this.name,
      this.date,
      this.email,
      this.imageURL
      );

  String key;
  String name;
  String date;
  String email;
  String imageURL;

  MemoryItem.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        name = snapshot.value['name'],
        date = snapshot.value['date'],
        email = snapshot.value['email'],
        imageURL = snapshot.value['imageURL'];

  toJson() {
    return {
      'name': name,
      'date': date,
      'email': email,
      'imageURL' : imageURL,
    };
  }
}