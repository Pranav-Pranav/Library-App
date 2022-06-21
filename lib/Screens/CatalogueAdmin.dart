import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/CartStudent.dart';
import 'CartStudent.dart';
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
    return Card(color: Colors.brown[50],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("id ",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("$id",style: TextStyle(fontSize: 12),),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("title",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("${book['title']}",style: TextStyle(fontSize: 12),),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("author",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("${book['author']}",style: TextStyle(fontSize: 12),),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("status",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0,2,8,2),
                  child: Text("${book['status']}",style: TextStyle(fontSize: 12,color: book['status']=='available'? Colors.green[600] : Colors.red),),
                )
              ]),
          Column(
            children: [
              SizedBox(width: 80,height: 30,child:ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.green[400],shape: StadiumBorder()),onPressed: book['status']=="available" ? null: (){
                final data = {"status": "available"};
                db.collection("books").doc(id).set(
                    data, SetOptions(merge: true)).then((value) => setState(() {
                                    book['status'] = "available";
                                  }));

              }, child: Text("return"))),
              SizedBox(height: 10),
              SizedBox(width: 80,height: 30,child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.redAccent,shape: StadiumBorder()),onPressed: (){
                delDialogue(BuildContext context){

                  return showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title:Text("Delete ${book['title']}"),
                      content: Text(""),
                      actions: [
                        ElevatedButton(onPressed: (){
                          db.collection("books").doc(id).delete().then((value) => Navigator.of(context).pop());
                        },child: Text("Delete")),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                        },child: Text("Cancel"))

                      ],);
                  });

                }

                delDialogue(context);

              }, child: Icon(Icons.delete))),
            ],
          )
        ],
      ),
    );
  }

}


class CatalogueAdmin extends StatefulWidget {
  List<String> idList;
  List<Map<String,dynamic>> books;
  List<Map<String,dynamic>>  filteredBookList=[];
  List<String> originalidList=[];


  CatalogueAdmin({required this.books,required this.idList}){
    originalidList=idList;
    print(books.length);
    for(Map<String,dynamic> book in books){
      print(book);
      if(book['status']==""){
        filteredBookList.add(book);
        idList.remove(books.indexWhere((e) => e==book));
      }
    }

  }
  @override
  State<CatalogueAdmin> createState() => _CatalogueAdminState(originalbooks:books,originalidList:originalidList,books:books,idList: idList);
}

class _CatalogueAdminState extends State<CatalogueAdmin> {
  addDialogue(BuildContext context){
    TextEditingController titleController=TextEditingController();
    TextEditingController authorController=TextEditingController();

    return showDialog(context: context, builder: (context){
    return AlertDialog(
        title:Text("Add Book"),
        content: Column(children: [
          TextField(decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"Book Title*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),controller: titleController),
          SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"Book Author*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),controller: authorController),
          SizedBox(height: 10),

        ],),
    actions: [
      ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.black,shape: StadiumBorder()),onPressed: (){
        db.collection("books").add({"title":titleController.text,"author":authorController.text,"status":"available"}).then((value) => Navigator.of(context).pop());
      },child: Text("Add")),
      ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.black,shape: StadiumBorder()),onPressed: (){
        Navigator.of(context).pop();
      },child: Text("Cancel"))

    ],);
    });

}
  editDialogue(BuildContext context){
    TextEditingController idController=TextEditingController();
    TextEditingController titleController=TextEditingController();
    TextEditingController authorController=TextEditingController();


    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title:Text("Edit Book"),
        content: Column(children: [
          TextField(decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"Book ID*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),controller: idController),
          SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"New title*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),controller: titleController),
          SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"New author*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),controller: authorController),
          SizedBox(height: 10)
        ],),
        actions: [
          ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.black,shape: StadiumBorder()),onPressed: (){
            db.collection("books").doc(idController.text).set({"title":titleController.text,"author":authorController.text}, SetOptions(merge: true)).then((value) => Navigator.of(context).pop());},
              child: Text("Make Changes")),
          ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.black,shape: StadiumBorder()),onPressed: (){
            Navigator.of(context).pop();
          },child: Text("Cancel"))

        ],);
    });

  }


  //Constructors
  List<Map<String,dynamic>> books;
  List<Map<String,dynamic>> originalbooks;
  List<String> originalidList;

  List<String> idList;

  _CatalogueAdminState({required this.originalbooks,required this.originalidList,required this.books,required this.idList});
  @override
  Widget build(BuildContext context) {
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
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Color.fromARGB(255, 61, 54, 53),shape: StadiumBorder()),onPressed: (){
                    addDialogue(context);

                  }, child: Icon(Icons.add)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Color.fromARGB(255, 61, 54, 53),shape: StadiumBorder()),onPressed: (){
                    editDialogue(context);
                  }, child: Icon(Icons.edit)),
                ),

              ],
            ),



          ],
        )
    );
  }
}

