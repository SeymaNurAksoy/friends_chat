import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:friendss_messenger/app/landing_file.dart';
import 'package:friendss_messenger/locator.dart';
import 'package:friendss_messenger/services/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friendss_messenger/view_model/user_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLacator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: MaterialApp(
            title: 'Flutter Lovers',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: LandingPage()),
      );
    }

}


