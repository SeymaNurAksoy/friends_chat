import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';
import '../model/user_model.dart';
import '../view_model/chat_view_model.dart';
import '../view_model/user_model.dart';
class SpeechPage extends StatefulWidget {
  @override
  _SpeechPage createState() => _SpeechPage();
}

class _SpeechPage extends State<SpeechPage> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  //InterstitialAd myInterstitialAd;

  @override
  void initState() {
    super.initState();
    /*if (AdmobIslemleri.myBannerAd != null) {
      print("my banner null oldu chat sayfasında");
      AdmobIslemleri.myBannerAd.dispose();
    }*/
    _scrollController.addListener(_scrollListener);
/*
    if (AdmobIslemleri.kacKereGosterildi <= 2) {
      myInterstitialAd = AdmobIslemleri.buildInterstitialAd();
      myInterstitialAd
        ..load()
        ..show();
      AdmobIslemleri.kacKereGosterildi++;
    }*/
  }

 /* @override
  void dispose() {
    if (myInterstitialAd != null) myInterstitialAd.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Column(
          children: <Widget>[
            _buildMesajListesi(),
            _buildYeniMesajGir(),
          ],
        ),
      ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            if (chatModel.hasMoreLoading &&
                chatModel.mesajlarListesi.length == index) {
              return _yeniElemanlarYukleniyorIndicator();
            } else
              return _talkBallonCreate(chatModel.mesajlarListesi[index]);
          },
          itemCount: chatModel.hasMoreLoading
              ? chatModel.mesajlarListesi.length + 1
              : chatModel.mesajlarListesi.length,
        ),
      );
    });
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _mesajController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mesajınızı Yazın",
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_mesajController.text.trim().length > 0) {
                  Message _kaydedilecekMesaj = Message(
                    kimden: _chatModel.currentUser.userId,
                    kime: _chatModel.sohbetEdilenUser.userId,
                    bendenMi: true,
                    konusmaSahibi: _chatModel.currentUser.userId,
                    mesaj: _mesajController.text,
                  );

                  var sonuc = await _chatModel.saveMessage(
                      _kaydedilecekMesaj, _chatModel.currentUser);
                  if (sonuc) {
                    _mesajController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }



  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async {
    final _chatModel = Provider.of<ChatViewModel>(context,listen: false);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _talkBallonCreate(Message oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                  NetworkImage(_chatModel.sohbetEdilenUser.profilUrl!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }
}
/*
class SpeechPage extends StatefulWidget{
   FUser? currentUser;
   FUser? callUser;

  SpeechPage(this.currentUser, this.callUser);

  @override
  State<StatefulWidget> createState() => _SpeechPage();

}
class _SpeechPage extends State<SpeechPage>{

  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    FUser currentUser= widget.currentUser!;
    FUser callUser= widget.callUser!;
    var _messageController =  TextEditingController();

    return Scaffold(
      appBar:  AppBar(
        title: Text("Sohpet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(child:StreamBuilder<List<Message>>(
              stream: _userModel.getMessages(currentUser.userId,callUser.userId),
              builder: (context,messagesList){
                if(!messagesList.hasData){
                  return Center( child: CircularProgressIndicator());
                }else{
                  var allMessage = messagesList.data;
                   return ListView.builder(
                       reverse: true,
                       controller: _scrollController,itemBuilder: (context,index){
                     return _talkBallonCreate(allMessage![index]);
                   },itemCount: allMessage!.length);
                }

              },

            )),
          Container(
            padding: EdgeInsets.only(bottom: 8,left: 8),
            child: Row(
              children: <Widget>[
                Expanded(child: TextField(
                  controller: _messageController,
                  cursorColor: Colors.blueGrey,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.black
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Mesajınızı Yazın",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      borderSide: BorderSide.none
                    )
                  ),
                )
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 4
                  ),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.navigation,
                        size: 35,
                        color: Colors.white),
                    onPressed: ()async{
                      if(_messageController.text.trim().length>0){
                        Message _saveMessage =Message(kimden:currentUser.userId, kime: callUser.userId,
                            bendenMi: true, mesaj: _messageController.text);

                       var result = await _userModel.saveMessage(_saveMessage);
                       if(result){
                         _messageController.clear();
                         _scrollController.animateTo(0,
                             duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                       }
                      }

                    },
                  ),
                )
              ],
            ),
          ),

          ],
        ),
      ),
    );
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  Widget _talkBallonCreate(Message oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    //final _chatModel = Provider.of<ChatViewModel>(context);
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                  NetworkImage(widget.callUser!.profilUrl!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

}*/