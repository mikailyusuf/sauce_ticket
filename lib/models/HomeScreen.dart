import 'package:flutter/material.dart';
import 'package:sauce_ticket/screens/TicketScreens.dart';
import 'package:sauce_ticket/screens/OrderedTickets.dart';
import 'package:sauce_ticket/screens/ProfileScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenNumber = 0;

  List<NavObject> navItems = [
    NavObject(
      screen: TicketScreen(),
      navIcon: Icon(Icons.train),
      title: Text('Tickets'),
    ),
    NavObject(
      screen: SavedTickets(),
      navIcon: Icon(Icons.bookmark_border_rounded),
      title: Text('Ordered Tickets'),
    ),
    NavObject(
      screen: Profile(),
      navIcon: Icon(Icons.person),
      title: Text('Profile'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navItems[_screenNumber].screen,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: navItems
            .map((navItem) => BottomNavigationBarItem(
          icon: navItem.navIcon,
          title: navItem.title,

        ))
            .toList(),
        currentIndex: _screenNumber,
        onTap: (i) => setState(() {
          _screenNumber = i;
        }),
      ),
    );
  }
}

class NavObject {
  Widget screen;
  Icon navIcon;
  Text title;
  NavObject({this.screen, this.navIcon, this.title});
}