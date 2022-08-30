


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:friendss_messenger/model/user_model.dart';

import '../model/message.dart';
import '../model/talk.dart';
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

  @override
  Future<List<FUser?>> getAllUser() async{
   QuerySnapshot _querySnapshot =  await _fireStore.collection("users").get();
   List<FUser> allusers =[];

   for(DocumentSnapshot user in _querySnapshot.docs){
     FUser user1 = FUser.fromMap(user.data() as Map<String,dynamic>);
     allusers.add(user1);
     print(user.data());
   }
   return allusers;
  }

  @override
  Stream<List<Message>> getMessage(String currentUserId,String callUserId)  {

    var snapShot = _fireStore
        .collection("konusmalar")
        .doc(currentUserId + "--" + callUserId)
        .collection("mesajlar")
        .orderBy("date",descending: true)
        .snapshots();
    var s= snapShot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Message.fromMap(mesaj.data())).toList());
    return s;
  }

  Future<bool> saveMessage(Message saveMessage)  async {
    var _mesajID = _fireStore.collection("konusmalar").doc().id;
    var _myDocumentID = saveMessage.kimden + "--" + saveMessage.kime;
    var _receiverDocumentID = saveMessage.kime + "--" + saveMessage.kimden;

    var _kaydedilecekMesajMapYapisi = saveMessage.toMap();

    await _fireStore.collection("konusmalar").doc(_myDocumentID).collection("mesajlar").doc(_mesajID).set(_kaydedilecekMesajMapYapisi);

    await _fireStore.collection("konusmalar").doc(_myDocumentID).set({
      "konusma_sahibi": saveMessage.kimden,
      "kimle_konusuyor": saveMessage.kime,
      "son_yollanan_mesaj": saveMessage.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);
    _kaydedilecekMesajMapYapisi.update("konusmaSahibi", (deger) => saveMessage.kime);

    await _fireStore.collection("konusmalar").doc(_receiverDocumentID).collection("mesajlar").doc(_mesajID).set(_kaydedilecekMesajMapYapisi);

    await _fireStore.collection("konusmalar").doc(_receiverDocumentID).set({
      "konusma_sahibi": saveMessage.kime,
      "kimle_konusuyor": saveMessage.kimden,
      "son_yollanan_mesaj": saveMessage.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }
  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _fireStore.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });

    var okunanMap = await _fireStore.collection("server").doc(userID).get();
    Timestamp okunanTarih = okunanMap.data()!["saat"];
    return okunanTarih.toDate();
  }

  @override
  Future<List<FUser>> getUserwithPagination(FUser? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<FUser> _tumKullanicilar = [];

    if (enSonGetirilenUser == null) {
      _querySnapshot = await FirebaseFirestore.instance.collection("users").orderBy("userName").limit(getirilecekElemanSayisi).get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      FUser _tekUser = FUser.fromMap(snap.data() as Map<String,dynamic>);
      _tumKullanicilar.add(_tekUser);
    }

    return _tumKullanicilar;


  }

  Future<List<Message>> getMessagewithPagination(String currentUserID, String sohbetEdilenUserID, Message? enSonGetirilenMesaj, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Message> _tumMesajlar = [];

    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _tekMesaj = Message.fromMap(snap.data() as Map<String,dynamic>);
      _tumMesajlar.add(_tekMesaj);
    }

    return _tumMesajlar;
  }

  @override
  Future<List<Talk>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot =
    await _fireStore.collection("konusmalar").where("konusma_sahibi",
        isEqualTo: userID).orderBy("olusturulma_tarihi", descending: true).get();

    List<Talk> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.docs) {
      Talk _tekKonusma = Talk.fromMap(tekKonusma.data() as Map<String,dynamic>);
      print("okunan konusma tarisi:" +
          _tekKonusma.olusturulma_tarihi.toDate().toString());
      tumKonusmalar.add(_tekKonusma);
    }
      var a= tumKonusmalar;
    return tumKonusmalar;
  }


}