import 'package:friendss_messenger/repository/user_repository.dart';
import 'package:friendss_messenger/services/fake_auth_service.dart';
import 'package:friendss_messenger/services/firebase_auth_service.dart';
import 'package:friendss_messenger/services/firebase_storage_services.dart';
import 'package:friendss_messenger/services/firestore_db_services.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;

void setupLacator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());

}
