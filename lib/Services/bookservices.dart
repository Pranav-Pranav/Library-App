import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFruits extends ChangeNotifier{
  String frut='unknown';

  void changeFruit(String newfruit){
    frut=newfruit;
    notifyListeners();
  }
}

class FetchBooks extends ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<Map<String,dynamic>> fetchedBooks=[];



  void fetchBooks() async{
    fetchedBooks=[];
    await db.collection("books").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        fetchedBooks.add(doc.data());
      }
      print("fetched books");
      print(fetchedBooks[0]);
      notifyListeners();
    }
    );
  }


}
