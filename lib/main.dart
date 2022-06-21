import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libraryapp/Screens/CatalogueAdmin.dart';
import 'package:libraryapp/Screens/CatalogueStudent.dart';
import 'Screens/signIn.dart';

void main() async{


WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyASurjfVv6dK3X1Z22e3cdnXSlYJoUJnkY', appId: 'com.example.libraryapp', messagingSenderId: '', projectId:'coffee-fd1fa'));
  var db = FirebaseFirestore.instance;
  List<Map<String,dynamic>> fetchedBooks=[];
  List<String> fetchedBooksid=[];

  await db.collection("books").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
      fetchedBooks.add(doc.data());
      fetchedBooksid.add(doc.id);
    }
  });

  //runApp(MaterialApp(home:Authenticate(books: fetchedBooks,idList: fetchedBooksid)));
  runApp(MaterialApp(home: Authenticate(books: fetchedBooks,idList: fetchedBooksid,)));


}










