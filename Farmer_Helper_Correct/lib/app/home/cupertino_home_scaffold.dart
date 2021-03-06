import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udemy_course/app/home/problems/add_problem_page.dart';
import 'package:udemy_course/app/home/tab_items.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetbuilders,
    @required this.navigatorKeys,
  }) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem,WidgetBuilder> widgetbuilders;
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys;



  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.homeTab),
          _buildItem(TabItem.latestProblems),
          _buildItem(TabItem.addProblems),
          _buildItem(TabItem.filters),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context,index){
        final item=TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context)=>widgetbuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
          itemData.title,
        style: TextStyle(color: color),

      ),
    );
  }
}
