
import 'package:flutter/material.dart';
import 'package:sauce_ticket/models/Ticket.dart';
import 'package:sauce_ticket/models/TicketsModel.dart';

class TicketDetailScreen extends StatefulWidget {

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();


  final Ticket _ticketsModel;

  TicketDetailScreen(this._ticketsModel);

}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._ticketsModel.start_destination +" -> "+ widget._ticketsModel.stop_destination),
      ),
      body: Container(
          child: Column(
            children: [
              SizedBox(height: 24.0,),
              Text(widget._ticketsModel.start_destination),
              SizedBox(height: 24.0,),
              Text(widget._ticketsModel.stop_destination),
              SizedBox(height: 24.0,),
              Text(widget._ticketsModel.price),
            ],
          )
        ),

    );
  }
}
