import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile({Key? key}) : super(key: key);

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class Cart extends StatefulWidget {
List<Map<String,dynamic>> bookList;
List<String> issueList;
Cart({required this.bookList,required this.issueList});
  @override
  State<Cart> createState() => _CartState(bookList: bookList,issueList:issueList);
}

class _CartState extends State<Cart> {
  List<Map<String,dynamic>> bookList;
  List<String> issueList;
  _CartState({required this.bookList,required this.issueList});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
