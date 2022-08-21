import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FUser {
  final String userId;
  String? userName;
  String? email;
  String? profilUrl;
  DateTime? createdOn;
  DateTime? updatedOn;
  int? seviye;

  FUser(this.userId,this.email);

  Map<String,dynamic> toMap(){
    return {
      "userID" : userId,
      "userName" : userName ?? email!.substring(0,email!.indexOf("@")) + randomSayiUret(),
      "email" :email ?? '',
      "profilUrl" : profilUrl ?? 'https://i.insider.com/61d46ade57bd6c001858760d?width=1200&format=jpeg',
      "createdOn" : createdOn ??  FieldValue.serverTimestamp(),
      "updatedOn" :updatedOn ?? FieldValue.serverTimestamp(),
      "seviye" :seviye ?? 1
    };
  }

  FUser.fromMap(Map<String,dynamic> map):
      userId = map["userID"],
      userName = map["userName"],
      email = map["email"],
      profilUrl = map["profilUrl"],
      createdOn = (map["createdOn"] as Timestamp).toDate(),
      updatedOn = (map["updatedOn"] as Timestamp).toDate(),
      seviye = map["seviye"];



  String randomSayiUret() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}