import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:friendss_messenger/locator.dart';
import 'package:friendss_messenger/model/user_model.dart';
import 'package:friendss_messenger/services/auth_base.dart';
import 'package:friendss_messenger/services/fake_auth_service.dart';
import 'package:friendss_messenger/services/firebase_auth_service.dart';

import '../services/firebase_storage_services.dart';
import '../services/firestore_db_services.dart';


enum AppMode{ DEBUG,RELEASE}
class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<
      FakeAuthenticationService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

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
}
