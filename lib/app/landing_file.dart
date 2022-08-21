import 'package:flutter/material.dart';

import 'package:friendss_messenger/app/home_page.dart';

import 'package:friendss_messenger/app/sign_in_page.dart';
import 'package:friendss_messenger/view_model/user_model.dart';
import 'package:provider/provider.dart';




class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: true);  // "listen" default olarak "true " kabul edildigi icin bunu yazmaya da bilisiniz
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.fUser == null) {
        return SignInPage();
      } else {
        return HomePage(fuser: _userModel.fUser!,);
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

