import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:friendss_messenger/locator.dart';
import 'package:friendss_messenger/model/message.dart';
import 'package:friendss_messenger/model/talk.dart';
import 'package:friendss_messenger/repository/user_repository.dart';
import 'package:friendss_messenger/services/auth_base.dart';

import '../model/user_model.dart';

enum ViewState{Idle,Busy}

class UserModel with ChangeNotifier implements AuthBase {

  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  FUser? _fUser ;

   String? emailErrorMessage;
   String? passwordErrorMessage;


  FUser? get fUser => _fUser;

  ViewState get state => _state;


  UserModel(){
    currentUser();
  }

  set state(ViewState value){
    _state=value;
    notifyListeners();
  }

  @override
  Future<FUser?> currentUser() async{
    try{
      state = ViewState.Busy;
      _fUser = (await _userRepository.currentUser())!;
      return _fUser;
    }catch(e){
      debugPrint("Viewmodelde ki current user hata:" +e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<FUser?> signInAnonymously() async{
    try{
      state = ViewState.Busy;
      _fUser = (await _userRepository.signInAnonymously())!;
      return _fUser;

    }catch(e){
      debugPrint("Viewmodelde ki signInAnonymously  user hata:" +e.toString());
      return null;
    }
    finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool?> signOut() async{
    try {
      state = ViewState.Busy;
      bool? sonuc = await _userRepository.signOut();
      _fUser = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<FUser?> signInWithGoogle() async {
    try{
      state = ViewState.Busy;
      _fUser = (await _userRepository.signInWithGoogle())!;
    return _fUser;

    }catch(e){
    debugPrint("Viewmodelde ki signInAnonymously  user hata:" +e.toString());
    return null;
    }
    finally{
    state = ViewState.Idle;
    }
  }

  @override
  Future<FUser?> signInWithFacebook() async {
    try{
      state = ViewState.Busy;
      _fUser = (await _userRepository.signInWithFacebook())!;
      return _fUser;

    }catch(e){
    debugPrint("Viewmodelde ki signInAnonymously  user hata:" +e.toString());
    return null;
    }
    finally{
    state = ViewState.Idle;
    }
  }

  @override
  Future<FUser?> createUserEmailAndPassword  (String? email, String? password) async {
    try{
      if(_emailPasswordControl(email!, password!)){
        state = ViewState.Busy;
        _fUser = await _userRepository.createUserEmailAndPassword(email, password);
        return _fUser;
      }else{
        return null;
      }
    }
    finally{
    state = ViewState.Idle;
    }
  }

  @override
  Future<FUser?> signInWithEmailAndPassword (String email, String password) async {
    try{
      if(_emailPasswordControl(email, password)){
        state = ViewState.Busy;
        _fUser = (await _userRepository.signInWithEmailAndPassword(email, password))!;
        return _fUser;
      }else{
        return null;
      }

    }
    finally{
    state = ViewState.Idle;
    }
  }

  bool _emailPasswordControl(String email,String password){
    var result = true;

    if(password.length <6){
      passwordErrorMessage = "En az 6 karakter olaml??d??r.";
      result = false;
    }else{
      passwordErrorMessage = null;
    }
    if(!email.contains("@")){

      emailErrorMessage = "Ge??ersiz email";
      result = false;
    }else{
      emailErrorMessage = null;
    }
    return result;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, newUserName);
    if (sonuc) {
      _fUser!.userName = newUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(String userId, String fileType, File profilFoto) async {
    var indirmeLinki = await _userRepository.uploadFile(userId, fileType, profilFoto);
    return indirmeLinki;
  }

  Future<List<FUser?>?> getAllUser() async {
    var allUser = await _userRepository.getAllUser();
    return allUser;
  }

  Stream<List<Message>> getMessages(String currentUser,String callUser) {
    return _userRepository.getMessage(currentUser,callUser);
  }

  Future<bool> saveMessage(Message saveMessage) {
    return _userRepository.saveMessage(saveMessage);
  }
  Future<List<Talk>> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }


}