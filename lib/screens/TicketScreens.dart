import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sauce_ticket/db/localDb.dart';
import 'package:sauce_ticket/models/OrderResponse.dart';
import 'package:sauce_ticket/models/OrderTicket.dart';
import 'package:sauce_ticket/models/TicketsModel.dart';
import 'package:http/http.dart' as http;
import 'package:sauce_ticket/models/Tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  Tokens token;

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String _token;

  @override
  initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    var ticketDb = await TicketDataBase.ticketDb.getToken();
    _token = ticketDb.access.toString();
  }

  void deleteToken(bool logged_in) async {
    var del = await TicketDataBase.ticketDb.delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("logged_in", logged_in);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    deleteToken(false);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (_) => false);
                    });
                  });
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: _buildTicketList(),
    );
  }

  Widget _buildTicketList() {
    return FutureBuilder<List<TicketsModel>>(
      future: fetchTicket(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print("Our Error ${snapshot.error} ");
        return snapshot.hasData
            ? TicketsList(tickets: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<TicketsModel>> fetchTicket(http.Client client) async {
    // getToken();
    String tt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyMDc1NzM0LCJqdGkiOiI3NGQ5ZWI3ZTRlNWY0NDAxYTIxNjczYmRhM2QyZGUzOCIsInVzZXJfaWQiOjV9.ci0_lFtxmG7WC34FxNkVRZQ81ZLOkWLNcqOhHG5Sxrk";
    print("REQUEST SENT");
    final response =
    await client.get('https://mikail-sauce.herokuapp.com/api/tickets/get_tickets',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $tt',
        });
    print("REQUEST RECEIVED ${response.body.toString()}");


    // Use the compute function to run parsePhotos in a separate isolate.
    return compute(parseTickets, response.body);
  }
  Widget date(String date)
  {
    String formatted = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    return Text(formatted);
  }


}

class TicketsList extends StatefulWidget {
  final List<TicketsModel> tickets;
  TicketsList({Key key, this.tickets}) : super(key: key);
  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  bool _isLoading = false;
   List<TicketsModel> _tickets;

   Widget date(String date)
   {
     String formatted = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
     return Text(formatted);
   }

   Future<dynamic> orderTicket(int id) {
     _isLoading = true;
     String error ;
     OrderTicket order = OrderTicket(ticket_id: id);
     String url =
         "https://mikail-sauce.herokuapp.com/api/tickets/reserve_ticket";
     String tt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyMDc1NzM0LCJqdGkiOiI3NGQ5ZWI3ZTRlNWY0NDAxYTIxNjczYmRhM2QyZGUzOCIsInVzZXJfaWQiOjV9.ci0_lFtxmG7WC34FxNkVRZQ81ZLOkWLNcqOhHG5Sxrk";

     print("ORDER  SENT");

     return http.post(url, headers: {
       HttpHeaders.authorizationHeader: 'Bearer $tt',
       'Content-Type': 'application/json; charset=UTF-8',
     },body:  jsonEncode(<String, int>{
       'ticket_id': id,
     })).then((http.Response response) {
       String data = response.body.toString();
       print("The Response body ${response.body.toString()} ");
       setState(() {
         _isLoading = false;
         AwesomeDialog(
           context: context,
           dialogType: DialogType.NO_HEADER,
           animType: AnimType.BOTTOMSLIDE,
           title: '',
           desc: '$data',
           btnCancelOnPress: () {
             // Navigator.pushNamedAndRemoveUntil(context,'/login',(_)=>false);
           },
           btnOkOnPress: () {

           },
         )..show();

       });
     }).catchError((Object error) {
print("error $error");

       AwesomeDialog(
         context: context,
         dialogType: DialogType.ERROR,
         animType: AnimType.BOTTOMSLIDE,
         title: 'Sorry',
         desc: '$error',
         btnCancelOnPress: () {
           // Navigator.pushNamedAndRemoveUntil(context,'/login',(_)=>false);
         },
         btnOkOnPress: () {

         },
       )..show();
       setState(() {
         _isLoading = false;
       });
     });
   }


   @override
  Widget build(BuildContext context) {
    List<TicketsModel> _tickets = widget.tickets;

    return (_isLoading)? Center(
      child: CircularProgressIndicator(),):Container(
      child: ListView.builder(
// _tickets[index].title
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: new InkWell(
              onTap: () {
                Future.delayed(Duration.zero, () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    animType: AnimType.BOTTOMSLIDE,
                    title:
                    '${_tickets[index].start_destination} -> ${_tickets[index].stop_destination}',
                    desc: 'Are You Sure You want to Order This Ticket',
                    btnCancelOnPress: () {
// Navigator.pushNamedAndRemoveUntil(context,'/login',(_)=>false);
                    },
                    btnOkOnPress: () {
                      setState(() {
                        orderTicket(_tickets[index].id.toInt());

                      });
// Navigator.pushNamedAndRemoveUntil(context,'/login',(_)=>false);
                    },
                  )..show();
// print("CARD CLICKED");
// print(_tickets[index].toString());
// Navigator.of(context)
//     .pushNamed('/detail', arguments: _tickets[index]);
                });
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(_tickets[index].start_destination),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_tickets[index].stop_destination),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_tickets[index].expired.toString()),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child:date(_tickets[index].date_created),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_tickets[index].price),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: _tickets.length,
      ),
    );
  }
}


List<TicketsModel> parseTickets(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<TicketsModel>((json) => TicketsModel.fromJson(json)).toList();
}

String parseOrder(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<OrderResponse>((json) => TicketsModel.fromJson(json)).toString();
}


