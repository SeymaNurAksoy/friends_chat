import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendss_messenger/app/home_page.dart';
import 'package:friendss_messenger/common_widget/social_login_button.dart';
import 'package:friendss_messenger/view_model/user_model.dart';
import 'package:provider/provider.dart';

import '../common_widget/platform_sensitive_alert_dialog.dart';
import '../model/user_model.dart';
import 'errors.dart';

enum FormType {Register , Login}

class EmailandPasswordLoginPage extends StatefulWidget{

  @override
  _EmailandPasswordLoginPageState createState() => _EmailandPasswordLoginPageState();
}
class   _EmailandPasswordLoginPageState extends State<EmailandPasswordLoginPage>{

   late String _email , _password;
   late String _buttonText, _linkText;
   var _formType = FormType.Login;

   final _formkey = GlobalKey<FormState>();

   void _formSubmit(BuildContext context ) async {

     _formkey.currentState?.save();
     debugPrint("email :" + _email.toString() + " password : "+ _password.toString());

     final _userModel = Provider.of<UserModel>(context,listen: false);
     if(_formType == FormType.Login) {
       try {
         var _loginUser = await _userModel.signInWithEmailAndPassword(
             _email, _password);
         print("LOGİN USER : " + _loginUser!.userId);
       } on FirebaseAuthException catch (e) {
         print("hata ${e.code}");

         PlatformSensitiveAlertDialog(
           title: "Oturum Açmada  Hata",
           content: Errors.goster(e.code),
           homeButtonText: "Tamam",
           cancelButtonText: "İptal",
         ).show(context);
       }
     }
       else{
       try{
         var _createUser = await _userModel.createUserEmailAndPassword(_email, _password) ;
         print("CREATE  USER : " + _createUser!.userId);
       }on FirebaseAuthException catch (e) {
         print("hata ${e.code}");

         PlatformSensitiveAlertDialog(
               title: "Kullanıcı Oluşturmada Hata",
               content: Errors.goster(e.code),
               homeButtonText: "Tamam",
               cancelButtonText: "İptal",
             ).show(context);


       }


     }

   }
  void _degistir (){
     setState(() {
       _formType = _formType == FormType.Login ? FormType.Register : FormType.Login;
     });
   }
  @override
  Widget build(BuildContext context) {

     _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
     _linkText = _formType == FormType.Login ? "Hesabınız Yok Mu Kayıt Ol" : "Hesabınız Var Mı ? Giriş Yapınız";

     final _userModel = Provider.of<UserModel>(context, listen: true);  // "listen" default olarak "true " kabul edildigi icin bunu yazmaya da bilisiniz

     if(_userModel.fUser != null){
       Future.delayed(Duration(microseconds: 10),(){
         Navigator.of(context).pop();
         });

     }

    return Scaffold(
     appBar: AppBar(
       actions:   <Widget>[
       ],
       title: Text("Giriş / Kayıt "),),
     body: _userModel.state == ViewState.Idle ?SingleChildScrollView(
       child: Padding(
         padding:  EdgeInsets.all(16.0),
         child: Form(
           //key: _formkey,
           child: Column(
           children:   <Widget>[
              TextField(
               keyboardType:  TextInputType.emailAddress,
               decoration:  InputDecoration(
                 errorText: _userModel.emailErrorMessage != null ? _userModel.emailErrorMessage : null,
                 prefixIcon: Icon(Icons.email),
                 hintText: 'Email',
                 labelText: 'Email',
                 border: OutlineInputBorder(),
               ),
               onChanged: (String loginEmail){
                 _email = loginEmail;
               },
             ),
             SizedBox(height: 8,),
              TextField(
                obscureText: true,
               decoration:  InputDecoration(
                 errorText: _userModel.passwordErrorMessage != null ? _userModel.passwordErrorMessage : null,
                 prefixIcon: Icon(Icons.password),
                 hintText: 'Password',
                 labelText: 'Password',
                 border: OutlineInputBorder(),
               ),
                onChanged: (String loginPassword){
                  _password = loginPassword;
                },
             ),
             SizedBox(height: 8,),
             SocialLogInButton(
               radius: 10,
               onPressed: () => _formSubmit(context),
               buttonText: _buttonText,
               buttonColor: Theme.of(context).primaryColor,
               buttonIcon: Icon(Icons.forward),),
             SizedBox(height: 8,),

             FlatButton(onPressed: ()=> _degistir(),
                 child: Text(_linkText))

           ],
         ),),
       ),
     ) : Center(child: CircularProgressIndicator(),)
   );
  }






}
