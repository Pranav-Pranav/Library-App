import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CatalogueAdmin.dart';
import 'CatalogueStudent.dart';
class Authenticate extends StatefulWidget {
  List<String> idList;
  List<Map<String,dynamic>> books;

  Authenticate({required this.books,required this.idList});
  @override
  State<Authenticate> createState() => _AuthenticateState(books:books,idList:idList);
}

class _AuthenticateState extends State<Authenticate> {
  List<String> idList;
  List<Map<String,dynamic>> books;
  _AuthenticateState({required this.books,required this.idList});

  GoogleSignIn _googleSignIn=GoogleSignIn(scopes:['email']);


  @override
  Widget build(BuildContext context) {
    TextEditingController usernameTextField=TextEditingController();
    TextEditingController passwordTextField=TextEditingController();
    GoogleSignInAccount? user=_googleSignIn.currentUser;

    void toCatalogueStudent() async{
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => CatalogueStudent(person: "shubham",books: books, idList: idList),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
    void toCatalogueAdmin() async{
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => CatalogueAdmin(books: books, idList: idList),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }

    void googleSignIn() async{
      try {
        await _googleSignIn.signIn().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => CatalogueStudent(person:"",books: books, idList: idList) )));
      } catch (error) {
        print(error);
      }
    }
    void apiSignIn(String username,String password) async{
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://sids438.pythonanywhere.com/login/'));
      request.body = json.encode({
        "username": username.toString(),
        "password": password.toString()
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
String x=await response.stream.bytesToString();
if(x=="Logged In"){
  toCatalogueStudent();
}
      }
      else {
        print(response.reasonPhrase);
      }

    }

    return Scaffold(
      body:Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 3*MediaQuery.of(context).size.width/5 , height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    SizedBox(height: 40),
                    SizedBox(width: 3*MediaQuery.of(context).size.width/5,child:Row(children: [Text("Login",style: TextStyle(fontSize: 50,fontWeight:FontWeight.bold))],),),
                    SizedBox(height: 15),
                    SizedBox(width: 3*MediaQuery.of(context).size.width/5,child:Row(children: [Text("BITS Pilani library app - an SUTT initiative",style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.grey))],),),
                    SizedBox(height: 15),
                    SizedBox(width: 3*MediaQuery.of(context).size.width/5,child:TextField(controller: usernameTextField,decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"Username*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))))),
                    SizedBox(height: 30),
                    SizedBox(width: 3*MediaQuery.of(context).size.width/5,child:TextField(controller: passwordTextField,obscureText: true,decoration: InputDecoration(labelStyle: TextStyle(fontSize: 12),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),contentPadding:EdgeInsets.all(10),labelText:"Password*",enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30))))),
                    SizedBox(height: 10),
                    SizedBox(height: 45,width: 3*MediaQuery.of(context).size.width/5, child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,primary: Color.fromARGB(255, 81, 56, 238),shape: StadiumBorder()),child: Text("Login"),onPressed: (){apiSignIn(usernameTextField.text,passwordTextField.text);}),),
                    SizedBox(height: 20),
                    Center(child:Text("or")),
                    SizedBox(height: 20),
                    SizedBox(height: 45,width: 3*MediaQuery.of(context).size.width/5, child: ElevatedButton(style: ElevatedButton.styleFrom(side: BorderSide(),elevation: 0,primary: Colors.white,shape: StadiumBorder()),child: Text("Sign in with Google",style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold)),onPressed: ()async{googleSignIn();})),

                  ],
                ),
              ),
            ],
          )
      ) ,
    );
  }
}
