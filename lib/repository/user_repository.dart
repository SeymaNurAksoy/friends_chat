import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:friendss_messenger/locator.dart';
import 'package:friendss_messenger/model/message.dart';
import 'package:friendss_messenger/model/user_model.dart';
import 'package:friendss_messenger/services/auth_base.dart';
import 'package:friendss_messenger/services/fake_auth_service.dart';
import 'package:friendss_messenger/services/firebase_auth_service.dart';

import '../model/talk.dart';
import '../services/firebase_storage_services.dart';
import '../services/firestore_db_services.dart';
import 'package:timeago/timeago.dart' as timeago;


enum AppMode{ DEBUG,RELEASE}
class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<
      FakeAuthenticationService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  List<FUser?> tumKullaniciListesi = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<FUser?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      FUser? _fUser = await _firebaseAuthService.currentUser();
      return await _fireStoreDBService.readUser(_fUser!.userId);
    }
  }

  @override
  Future<FUser?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<FUser?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      FUser? _fUser = await _firebaseAuthService.signInWithGoogle();
      bool result = await _fireStoreDBService.saveUser(_fUser!);
      if (result) {
        return await _fireStoreDBService.readUser(_fUser.userId);
      } else {
        return null;
      }
    }
  }

  @override
  Future<FUser?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      return await _firebaseAuthService.signInWithFacebook();
    }
  }

  @override
  Future<FUser?> createUserEmailAndPassword(String email,
      String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserEmailAndPassword(
          email, password);
    } else {
      FUser? _fUser = await _firebaseAuthService.createUserEmailAndPassword(
          email, password);
      bool result = await _fireStoreDBService.saveUser(_fUser!);
      if (result) {
        return await _fireStoreDBService.readUser(_fUser.userId);
      } else {
        return null;
      }
    }
  }

  @override
  Future<FUser?> signInWithEmailAndPassword(String email,
      String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailAndPassword(
          email, password);
    } else {
      FUser? _user = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      return await _fireStoreDBService.readUser(_user!.userId);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDBService.updateUserName(userID, newUserName);
    }
  }


  Future<String> uploadFile(String userId, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(userId, fileType, profilFoto);
      await _fireStoreDBService.updateProfilFoto(userId, profilFotoURL);
      return profilFotoURL;
    }
  }

  Future<List<FUser?>> getAllUser() async{
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi= await _fireStoreDBService.getAllUser();
      return tumKullaniciListesi;
    }
  }

  Stream<List<Message>> getMessage(String currentUser, String callUser) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessage(currentUser, callUser);
    }
  }

  Future<bool> saveMessage(Message kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var dbYazmaIslemi = await _fireStoreDBService.saveMessage(kaydedilecekMesaj);

      return dbYazmaIslemi;


    }
  }
  Future<List<Talk>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _fireStoreDBService.saatiGoster(userID);

      var konusmaListesi = await _fireStoreDBService.getAllConversations(userID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici = listedeUserBul(oankiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          //print("VERILER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL = userListesindekiKullanici.profilUrl;
        } else {
          //print("VERILER VERITABANINDAN OKUNDU");
          /*print(
              "aranılan user daha önceden veritabanından getirilmemiş, o yüzden veritabanından bu degeri okumalıyız");*/
          var _veritabanindanOkunanUser = await _fireStoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfilURL = _veritabanindanOkunanUser.profilUrl;
        }

        timeagoHesapla(oankiKonusma, _zaman);
      }

      return konusmaListesi;
    }
  }
  void timeagoHesapla(Talk oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.aradakiFark = timeago.format(zaman.subtract(_duration), locale: "tr");
  }
  FUser? listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i]!.userId == userID) {
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }
  Future<List<FUser>> getUserwithPagination(FUser? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<FUser> _userList = await _fireStoreDBService.getUserwithPagination(enSonGetirilenUser, getirilecekElemanSayisi);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Message>> getMessageWithPagination(String currentUserID, String sohbetEdilenUserID, Message? enSonGetirilenMesaj, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _fireStoreDBService.getMessagewithPagination(currentUserID, sohbetEdilenUserID, enSonGetirilenMesaj, getirilecekElemanSayisi);
    }
  }
}
