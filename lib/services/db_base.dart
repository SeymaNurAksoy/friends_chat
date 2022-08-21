import '../model/user_model.dart';

abstract class DBBase{

  Future<bool> saveUser(FUser fuser);
  Future<FUser> readUser(String userId);
  Future<bool> updateUserName(String userID, String yeniUserName) ;

}