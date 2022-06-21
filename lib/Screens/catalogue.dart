import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libraryapp/Services/bookservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Tile extends StatelessWidget {
  Map<String,dynamic> book;
  String id;
  Tile({required this.book,required this.id});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          var db = FirebaseFirestore.instance;
          final data={"status":"false"};
          //db.collection("books").doc(id).set(data, SetOptions(merge: true));
         // Provider.of<FetchBooks>(context,listen: false).fetchBooks();
        },
        child: Text(book['title']));
  }
}

class Catalogue extends StatefulWidget {
//  const Catalogue({Key? key}) : super(key: key);
List books;
Catalogue({required this.books});
  @override
  State<Catalogue> createState() => _CatalogueState(books: books);
}

class _CatalogueState extends State<Catalogue> {
  List books;

  _CatalogueState({required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: Provider.of<FetchBooks>(context).fetchedBooks.map((e) => Text(e['title'])).toList()),
    );
  }
}
