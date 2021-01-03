  import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
    @override
    _ProfileState createState() => _ProfileState();
  }

  class _ProfileState extends State<Profile> {
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text("Profile Screen"),
      );
    }
  }


  class SavedTickets extends StatefulWidget {
    @override
    _SavedTicketsState createState() => _SavedTicketsState();
  }

  class _SavedTicketsState extends State<SavedTickets> {
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text("Saved Tickets"),
      );
    }
  }

