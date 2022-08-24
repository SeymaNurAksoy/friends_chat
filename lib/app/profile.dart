
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendss_messenger/common_widget/platform_sensitive_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common_widget/social_login_button.dart';
import '../view_model/user_model.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}
class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _controllerUserName;
  File? profilFoto;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
var pickedFoto= await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      profilFoto= File(pickedFoto!.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var pickedFoto= await ImagePicker().getImage(source: ImageSource.gallery);


    setState(() {
      profilFoto= File(pickedFoto!.path);
      Navigator.of(context).pop();
    });
  }
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.fUser!.userName!;
    print("Profil sayfasındaki user degerleri :" + _userModel.fUser.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _askForConfirmationToExit(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: defImage(profilFoto,_userModel),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.fUser!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SocialLogInButton(
                  radius: 10,
                  buttonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _askForConfirmationToExit(BuildContext context) async {
    final sonuc = await PlatformSensitiveAlertDialog(
      title: "Emin Misiniz?",
      content: "Çıkmak istediğinizden emin misiniz?",
      homeButtonText: "Evet",
      cancelButtonText: "Vazgeç",
    ).show(context);

    if (sonuc == true) {
      _exit(context);
    }
  }

  Future<bool?> _exit(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool? result = await _userModel.signOut();
    print("BOOL SİGNOUT" + result.toString());
    return result;
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.fUser!.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(_userModel.fUser!.userId, _controllerUserName.text);

      if (updateResult == true) {
        PlatformSensitiveAlertDialog(
          title: "Başarılı",
          content: "Username değiştirildi",
          homeButtonText: 'Tamam',
          cancelButtonText: 'İptal',
        ).show(context);
      } else {
        _controllerUserName.text = _userModel.fUser!.userName!;
        PlatformSensitiveAlertDialog(
          title: "Hata",
          content: "Username zaten kullanımda, farklı bir username deneyiniz",
          homeButtonText: 'Tamam',
          cancelButtonText: '',
        ).show(context);
      }
    }
  }

  defImage(imageXFile,_userModel) {
    if(imageXFile == null){
     return NetworkImage(_userModel.fUser!.profilUrl!);
    }else{

     return  FileImage(File(imageXFile!.path));
    }
  }
  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (profilFoto != null) {
      var url = await _userModel.uploadFile(_userModel.fUser!.userId, "profil_foto", profilFoto!);
      //print("gelen url :" + url);

      if (url != null) {
        PlatformSensitiveAlertDialog(
          title: "Başarılı",
          content: "Profil fotoğrafınız güncellendi",
          homeButtonText: 'Tamam',
          cancelButtonText: "İptal",
        ).show(context);
      }
    }
  }
}

/**/

