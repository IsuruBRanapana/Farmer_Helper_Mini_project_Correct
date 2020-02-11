import 'package:flutter/material.dart';

enum TabItem{homeTab, latestProblems, addProblems, filters, account}

class TabItemData{
  const TabItemData({@required this.title,@required this.icon});
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs={
    TabItem.homeTab:TabItemData(title: 'Home',icon: Icons.home),
    TabItem.latestProblems:TabItemData(title: 'Latest Problems',icon: Icons.star),
    TabItem.addProblems:TabItemData(title: 'Add Problems',icon: Icons.add),
    TabItem.filters:TabItemData(title: 'Filters',icon: Icons.filter_list),
    TabItem.account:TabItemData(title: 'Account',icon: Icons.person)
  };
}