import 'package:friendss_messenger/model/message.dart';

import '../model/talk.dart';
import '../model/user_model.dart';

abstract class DBBase{

  Future<bool> saveUser(FUser fuser);
  Future<FUser> readUser(String userId);
  Future<bool> updateUserName(String userID, String yeniUserName) ;
  Future<bool> updateProfilFoto(String userID, String yeniUserName) ;
  Future<List<FUser?>?> getAllUser();
  Stream<List<Message>> getMessage(String currentUserId,String callUserId);
  Future<bool> saveMessage(Message saveMessage);
  Future<List<Talk>> getAllConversations(String userID);
  Future<DateTime> saatiGoster(String userID);

}