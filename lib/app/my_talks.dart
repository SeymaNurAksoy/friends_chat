import 'package:flutter/material.dart';
import 'package:friendss_messenger/app/speech_page.dart';
import 'package:friendss_messenger/model/talk.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../view_model/chat_view_model.dart';
import '../view_model/user_model.dart';

class MyTalks extends StatefulWidget {
  @override
  _MyTalksState createState() => _MyTalksState();
}

class _MyTalksState extends State<MyTalks> {
  @override
  void initState() {
    super.initState();
    /*RewardedVideoAd.instance.load(
        adUnitId: AdmobIslemleri.odulluReklamTest,
        targetingInfo: AdmobIslemleri.targetingInfo);

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print(" *************** ODULLU REKLAM ***** ODUL VER");
        odulluReklamLoad();
      } else if (event == RewardedVideoAdEvent.loaded) {
        print(
            " *************** ODULLU REKLAM ***** REKLAM yuklendı ve gosterilecek");
        RewardedVideoAd.instance.show();
      } else if (event == RewardedVideoAdEvent.closed) {
        print(" *************** ODULLU REKLAM ***** REKLAM KAPATILDI");
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        print(" *************** ODULLU REKLAM ***** REKLAM BULUNAMADI");
        odulluReklamLoad();
      } else if (event == RewardedVideoAdEvent.completed) {
        print(" *************** ODULLU REKLAM ***** COMPLETED");
      }
    };*/
  }

  /*void odulluReklamLoad() {
    RewardedVideoAd.instance.load(
        adUnitId: AdmobIslemleri.odulluReklamTest,
        targetingInfo: AdmobIslemleri.targetingInfo);
  }*/

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Konusmalarım"),
      ),
      body: FutureBuilder<List<Talk>>(
        future: _userModel.getAllConversations(_userModel.fUser!.userId),
        builder: (context, talkList) {
          if (!talkList.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = talkList.data;

            if (tumKonusmalar!.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(

                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatViewModel(
                                  currentUser: _userModel.fUser!,
                                  sohbetEdilenUser: FUser.idveResim(
                                      userId: oankiKonusma.kimle_konusuyor,
                                      profilUrl:
                                          oankiKonusma.konusulanUserProfilURL)),
                              child: SpeechPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiKonusma.son_yollanan_mesaj),
                        subtitle: Text(oankiKonusma.konusulanUserName! +
                            "  " +
                            oankiKonusma!.aradakiFark!),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage:
                              NetworkImage(oankiKonusma.konusulanUserProfilURL!),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüz Konusma Yapılmamış",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<Null> _konusmalarimListesiniYenile() async {

    setState(() {

    });
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
