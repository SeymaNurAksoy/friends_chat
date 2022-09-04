
import 'package:flutter/material.dart';
import 'package:friendss_messenger/app/my_custom_buttom_navi.dart';
import 'package:friendss_messenger/app/profile.dart';
import 'package:friendss_messenger/app/tab_items.dart';
import 'package:friendss_messenger/app/users_home_page.dart';
import 'package:friendss_messenger/model/user_model.dart';
import 'package:friendss_messenger/view_model/all_users_view_model.dart';
import 'package:friendss_messenger/view_model/user_model.dart';
import 'package:provider/provider.dart';

import 'my_talks.dart';


class HomePage extends StatefulWidget {
  FUser fuser;
  HomePage({Key? key,required this.fuser}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{

  TabItem _currentTab = TabItem.Kullanicilar;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };
  Map<TabItem,Widget> allPage () {
    return{
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: UsersPage(),
      ),      TabItem.Konusmalarim: MyTalks(),
      TabItem.Profil: ProfilPage(),
    };
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: MyCustomBottomNavigation(_currentTab, (secilenTab) {
          if(secilenTab==_currentTab){
            navigatorKeys[secilenTab]!.currentState!.popUntil((route) => route.isFirst);
          }else{
            setState(() {
              _currentTab = secilenTab;
            });
        }
      },allPage(),navigatorKeys)
    );
  }

   /* Future<bool?> _cikisYap(BuildContext context) async {
      final _userModel = Provider.of<UserModel>(context,listen: false);
      bool? result = await _userModel.signOut();
      print("BOOL SİGNOUT" + result.toString());
      return  result;
    }*/

}