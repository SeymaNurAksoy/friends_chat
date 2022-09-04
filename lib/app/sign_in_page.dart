
import 'package:flutter/material.dart';
import 'package:friendss_messenger/common_widget/social_login_button.dart';
import 'package:friendss_messenger/view_model/user_model.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import 'email_password_login_page.dart';

class SignInPage extends StatelessWidget {


  void _emailAndPasswordlogin(BuildContext context){

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=> EmailandPasswordLoginPage()));
  }
  void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    FUser?  _user =  await _userModel.signInAnonymously();
    print("Oturum açan kullanıcı id: " + _user!.userId.toString());
    print("state : " + _userModel.state.toString());

  }
  void _googleWithSign(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    FUser?  _user =  await _userModel.signInWithGoogle();
    print("Oturum açan kullanıcı id: " + _user!.userId.toString());
    print("state : " + _userModel.state.toString());

  }
  void _facebookWithSign(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    FUser?  _user =  await _userModel.signInWithFacebook();
    //print("Oturum açan kullanıcı id: " + _user!.userId.toString());
    //print("state : " + _userModel.state.toString());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FRİENDS MESSENGER"),
        //aşağıda ki gölgelik
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Container(

        padding: EdgeInsets.all((16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children:   <Widget>[
            const Text("MERHABA ARKADAŞIM 😎",textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32
              ),
            ),
            new Image.asset("images/chat.png",cacheHeight: 300,cacheWidth: 300),
            const Text("OTURUM AÇMAYA NE DERSİN 🥰 ",textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32
            ),
            ),
            const SizedBox(
              height: 8,
            ),
              SocialLogInButton(
              buttonIcon: Image.asset("images/google.png",height: 30,width: 30),
              buttonColor: Colors.white,
              buttonText: "Google İle Oturum Aç",
              radius: 16,
              onPressed: ()=> _googleWithSign(context),
              textColor: Colors.black87,
            ),
            /*SocialLogInButton(
              buttonIcon: Image.asset("images/facebook.png",height: 30,width: 30),
              buttonColor: Color(0xFF334D92),
              buttonText: "Facebook İle Oturum Açınız",
              radius: 16,
              onPressed: ()=>_facebookWithSign(context),
              textColor: Colors.white,
            ),*/
            SocialLogInButton(
              buttonIcon: Icon(Icons.email,color: Colors.white,size: 35,),
              buttonColor: Colors.teal,
              buttonText: "Email ve Şİfreyle Giriş Yap",
              radius: 16,
              onPressed: ()=> _emailAndPasswordlogin(context),
              textColor: Colors.white,
            ),
          /*  SocialLogInButton(
              buttonIcon: Icon(Icons.supervised_user_circle,size: 35,color: Colors.white),
              buttonColor: Colors.deepOrangeAccent,
              buttonText: "Misafir Girişi",
              radius: 16,
              onPressed: () => _misafirGirisi(context),
              textColor: Colors.white,
            ),*/

          ],
        ),
      ),
    );  }





}