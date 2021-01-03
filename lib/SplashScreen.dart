import 'package:flutter/material.dart';
import 'package:sauce_ticket/authScreens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'authScreens/TicketScreens.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _status = false;
  final String assetName = 'assets/rail.svg';

  @override
  void initState() {
    super.initState();
    _getUserStatus();
  }
  final Widget svg = SvgPicture.asset(
      'assets/rail.png',
      color: Colors.red,
      semanticsLabel: 'Train Logo'
  );


  // _status ?Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false):Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds:4,
      navigateAfterSeconds:_status?Home():LoginScreen(),
        title: new Text('Welcome to Sauce Ticket',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image:Image.asset('assets/images/rail.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.red


    );
  }

  _getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = (prefs.getBool('registered') ?? false);
    });
  }
}
