

import 'package:flutter/material.dart';
import 'package:sauce_ticket/TicketDetailScreen.dart';
import 'package:sauce_ticket/authScreens/LoginScreen.dart';
import 'package:sauce_ticket/authScreens/RegisterUser.dart';
import 'package:sauce_ticket/authScreens/TicketScreens.dart';

import 'models/TicketsModel.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
          return MaterialPageRoute(
            builder: (_) => RegisterUser(),
          );
      case '/home':
        return MaterialPageRoute(builder: (_)=>TicketScreen());
      case '/detail':

        TicketsModel data = args;

        return MaterialPageRoute(builder: (_)=>TicketDetailScreen(data));

        // return _errorRoute();
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}