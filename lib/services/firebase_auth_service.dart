import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:friendss_messenger/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';

class FirebaseAuthService implements AuthBase{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<FUser?> currentUser() async {
    try{
      User user = await _firebaseAuth.currentUser!;
      return _userFromFirebase(user);
    }catch(e){
      print("HATA CURRENT USER " + e.toString());
    }

  }

  FUser? _userFromFirebase(User? user){
    if(user == null){
      return null;
    }

    return FUser(user.uid,user.email!);

  }

  @override
  Future<FUser?> signInAnonymously()  async{
    try{
      UserCredential sonuc=  await FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebase(sonuc.user);

    }catch(e){
      print("HATA ANONİM GİRİŞ " + e.toString());
    }
  }

  @override
  Future<bool?> signOut() async {
    try{
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await  _firebaseAuth.signOut();
      return null;
    }catch(e){
      print("HATA SIGN OUT  " + e.toString());
    }


  }

  @override
  Future<FUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if(_googleUser != null){
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if(_googleAuth.idToken != null && _googleAuth.accessToken != null){
        UserCredential sonuc = await  _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken)
        );
        User? user = sonuc.user;
        return _userFromFirebase(user);
      }else{
        return null;
      }
    }else{
      return null;
    }


  }

  @override
  Future<FUser?> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();

    FacebookLoginResult _result= await  _facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile]);
    switch(_result.status){
      case FacebookLoginStatus.success:
          UserCredential _firebaseResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(_result.accessToken!.token.toString()));
          User? user = _firebaseResult.user;
          return _userFromFirebase(user);

      case FacebookLoginStatus.cancel:
        print("Kullanıcı girişi iptal etmiştir.");
        break;
      case FacebookLoginStatus.error:
        print("Hata çıktı : "+ _result.error.toString());
        break;
    }
    return null;

  }

  @override
  Future<FUser?> createUserEmailAndPassword(String email, String password) async {
      UserCredential sonuc=  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);
  }

  @override
  Future<FUser?> signInWithEmailAndPassword(String email, String password) async {

      UserCredential sonuc=  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);

  }


}