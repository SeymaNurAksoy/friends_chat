import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendss_messenger/model/user_model.dart';

abstract class AuthBase{
  Future<FUser?> currentUser ();
  Future<FUser?> signInAnonymously ();
  Future<bool?> signOut ();
  Future<FUser?> signInWithGoogle();
  Future<FUser?> signInWithFacebook();
  Future<FUser?> signInWithEmailAndPassword(String email,String password);
  Future<FUser?> createUserEmailAndPassword(String email,String password);


}