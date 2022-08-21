import 'package:flutter/material.dart';


class  UsersHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
             ),
      body: Center(child: Text("Kullanıcılar  Sayfası"),),
    );
  }

}