


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:friendss_messenger/model/user_model.dart';

import 'db_base.dart';

class FireStoreDBService implements DBBase{

  final FirebaseFirestore  _fireStore = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(FUser fuser) async {
    Map<String,dynamic> _addUser = fuser.toMap();
    _addUser['createdOn'] = FieldValue.serverTimestamp();
    _addUser['updatedOn'] = FieldValue.serverTimestamp();

    await _fireStore.collection("users").doc(fuser.userId).set(_addUser);

    DocumentSnapshot _readUser = await FirebaseFirestore.instance.doc("users/${fuser.userId}").get();
    _readUser.data();


    Object? _readUserInformation = _readUser.data()  ;

    print("*************************** "+_readUserInformation.toString()+"*************");

    return true;

  }

  @override
  Future<FUser> readUser(String userId) async {
    DocumentSnapshot _readUser = await FirebaseFirestore.instance.doc("users/${userId}").get();
    _readUser.data();
    Object? _readUserInformation = _readUser.data();
    FUser _readUserMap = FUser.fromMap(_readUserInformation as Map<String,dynamic>);
    print(_readUserMap.toString()+"OKUNAN KULANICI");
    return _readUserMap;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _fireStore.collection("users").where("userName", isEqualTo: newUserName).get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _fireStore.collection("users").doc(userID).update({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _fireStore.collection("users").doc(userID).update({'profilUrl': profilFotoURL});
    return true;
  }
}