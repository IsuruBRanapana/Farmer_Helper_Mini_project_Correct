import 'package:flutter/material.dart';
import 'package:udemy_course/app/home/account/account.dart';
import 'package:udemy_course/app/home/cupertino_home_scaffold.dart';
import 'package:udemy_course/app/home/entries/entries_page.dart';
import 'package:udemy_course/app/home/problems/add_problem_page.dart';
import 'package:udemy_course/app/home/tab_items.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys ={
    TabItem.homeTab : GlobalKey<NavigatorState>(),
    TabItem.latestProblems : GlobalKey<NavigatorState>(),
    TabItem.addProblems : GlobalKey<NavigatorState>(),
    TabItem.filters : GlobalKey<NavigatorState>(),
    TabItem.account : GlobalKey<NavigatorState>(),
  };
  TabItem _currentTab=TabItem.homeTab;
  Map<TabItem,WidgetBuilder> get widgetbuilders{
    return {
      TabItem.homeTab:(context)=>EntriesPage.create(context),
      TabItem.latestProblems :(_)=>Container(),
      TabItem.addProblems:(_)=>AddProblemPage(),
      TabItem.filters :(_)=>Container(),
      TabItem.account:(_)=>AccountPage(),
    };
  }
  void _select(TabItem tabItem) {
    if(tabItem==_currentTab){
      navigatorKeys[tabItem].currentState.popUntil((route)=>route.isFirst);
    }else {
      setState(() => _currentTab = tabItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>!await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetbuilders: widgetbuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }


}
