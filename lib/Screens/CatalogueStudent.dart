import 'package:flutter/material.dart';
import 'signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db=FirebaseFirestore.instance;
List<String >issueList=[];


class Tile extends StatefulWidget {
  Map<String,dynamic> book;
  String id;
  Tile({required this.book,required this.id});

  @override
  State<Tile> createState() => _TileState(book:book,id:id);
}
class _TileState extends State<Tile> {
  Map<String,dynamic> book;
  String id;
  _TileState({required this.book,required this.id});

  @override
  Widget build(BuildContext context) {

    bool? _isChecked=false;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return CheckboxListTile(subtitle: Text(book['author']),title: Text(book['title']),
              value: _isChecked,
              onChanged: (bool? newValue){setState((){_isChecked=newValue;
              if(newValue==true){
                addToCart(id);
              }
              else{
                removeFromCart(id);
              }
              });}
          );
        });
  }

}

void addToCart(String bookId){
  issueList.add(bookId);
  print(issueList);
}

void removeFromCart(String bookId){
  issueList.remove(bookId);
  print(issueList);
}



class CatalogueStudent extends StatefulWidget {
  String person;
  List<String> idList;
  List<Map<String,dynamic>> books;
  List<Map<String,dynamic>>  filteredBookList=[];
  List<String> filteredIdList=[];


  CatalogueStudent({required this.person,required this.books,required this.idList}){
    for(int i=0; i<books.length;i++){
      if(books[i]['status']=="available"){
        filteredBookList.add(books[i]);
        filteredIdList.add(idList[i]);
      }
    }

  }
  @override
  State<CatalogueStudent> createState() => _CatalogueStudentState(person: person,originalbooks:books,originalidList:idList,books:filteredBookList,idList: filteredIdList);
}

class _CatalogueStudentState extends State<CatalogueStudent> {
  //Constructors
  String person;
  List<Map<String,dynamic>> books;
  List<Map<String,dynamic>> originalbooks;
  List<String> originalidList;
  List<String> idList;

  _CatalogueStudentState({required this.person,required this.originalbooks,required this.originalidList,required this.books,required this.idList}){print(idList);}

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> refreshedList=books;

    return Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height-80,
              width: MediaQuery.of(context).size.width,


              child: ListView(
                  children: books.map((e) => Tile(book: e,id: idList[books.indexWhere((book) => book==e)])).toList()
              ),
            ),
            //ElevatedButton(onPressed: (){                for (String id in originalidList) {
             // final data = {"status": "available"};
             // db.collection("books").doc(id).set(
               //   data, SetOptions(merge: true));
            //}
            //} ,child: Text("reset")),
            ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Color.fromARGB(255, 81, 56, 238),shape: StadiumBorder()),onPressed:
                () {
              setState(() {
                print("before");
                print(refreshedList);
List<int> indexToRemove=[];
                for (String id in issueList) {
                  final data = {"status": "${person}"};
                  db.collection("books").doc(id).set(
                      data, SetOptions(merge: true));
                   indexToRemove.add(idList.indexWhere((element) => element==id));
                   
                };
indexToRemove.sort();
print(indexToRemove);

int n=0;
                for(int i in indexToRemove){
                  i=i-n;
                  refreshedList.removeAt(i);//BUG skips through this statement
                  print(refreshedList);//BUG
                  n=n+1;
                }
                print("after");
                print(refreshedList);
                });
              books=[];
            //  for(Map<String,dynamic> i in refreshedList){
              //  books.add(i);
              //}
              print("final");
              print(refreshedList);
              books=refreshedList;
     ;},
                child: Text("Issue")),

          ],
        )
    );
  }
}


