import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendss_messenger/app/tab_items.dart';


class MyCustomBottomNavigation extends StatelessWidget {
  MyCustomBottomNavigation(this.currentTab, this.onSelectedTab,this.pageCreate, this.navigatorKeys);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem,Widget> pageCreate;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;



  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
      items: [
        _navigationBarItemCreate(TabItem.Kullanicilar),
        _navigationBarItemCreate(TabItem.Profil),
      ],
      onTap: (index)=> onSelectedTab(TabItem.values[index]),
    ), tabBuilder: (BuildContext context, int index) {
      final showItem = TabItem.values[index];
      return CupertinoTabView(
        navigatorKey: navigatorKeys[showItem],
        builder: (context) {
          return  pageCreate[showItem] as Widget;
        }
      );
    },);
  }

  BottomNavigationBarItem _navigationBarItemCreate(TabItem item){
    final currenTab = TabItemData.tumTablar[item];
    return BottomNavigationBarItem(icon: Icon(currenTab?.icon),
      label: currenTab?.title,
    );
  }
}