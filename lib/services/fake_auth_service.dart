import 'package:friendss_messenger/model/user_model.dart';
import 'package:friendss_messenger/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase{
  String? userId="5641654878456456445456456";
  @override
  Future<FUser?> currentUser() async{
    return await Future.value(FUser(userId!,""));
  }

  @override
  Future<FUser?> signInAnonymously() async{
   return await Future.delayed(Duration(seconds: 2),()=>FUser(userId!,""));
  }

  @override
  Future<bool?> signOut() async{
    return Future.value(true);
  }

  @override
  Future<FUser?> signInWithGoogle()  async{
    return await Future.delayed(Duration(seconds: 2),()=>FUser("google_user_id_654564654",""));

  }

  @override
  Future<FUser?> signInWithFacebook()  async{
    return await Future.delayed(Duration(seconds: 2),()=>FUser("facebook_user_id_654564654",""));

  }

  @override
  Future<FUser?> createUserEmailAndPassword(String email, String password) async{
    return await Future.delayed(Duration(seconds: 2),()=>FUser("createuser_user_id_654564654",""));

  }

  @override
  Future<FUser?> signInWithEmailAndPassword(String email, String password) async {
    return await Future.delayed(Duration(seconds: 2),()=>FUser("signuser_user_id_654564654",""));

  }


}