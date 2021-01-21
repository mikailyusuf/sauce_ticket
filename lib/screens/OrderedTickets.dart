import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sauce_ticket/db/localDb.dart';
import 'package:sauce_ticket/models/ReservedTickets.dart';
import 'package:sauce_ticket/models/Ticket.dart';
import 'package:sauce_ticket/models/TicketsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SavedTickets extends StatefulWidget {
  @override
  _SavedTicketsState createState() => _SavedTicketsState();
}

class _SavedTicketsState extends State<SavedTickets> {
  List<ReservedTickets> _reserverdTickets = [];
  String _token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  int user_id;

  @override
  initState() {
    super.initState();
    getToken();
    getUserId();
    fetchUserTickets();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id =  prefs.getInt("userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tickets"),
        automaticallyImplyLeading: false,

      ),
      body: FutureBuilder<List<ReservedTickets>>(
        future: fetchReserverdTickets(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? OrderedTicketList(tickets: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<dynamic> _onRefresh() {
    return fetchUserTickets();
  }

  // Widget _buildTicketList() {
  //   return RefreshIndicator(
  //     onRefresh: _onRefresh,
  //     key: _refreshIndicatorKey,
  //     child: ListView.builder(
  //       // _tickets[index].title
  //       itemBuilder: (BuildContext context, int index) {
  //         return Card(
  //           child: new InkWell(
  //             onTap: () {
  //               Future.delayed(Duration.zero, () {
  //                 Navigator.of(context)
  //                     .pushNamed('/detail', arguments: _reserverdTickets[index].ticket);
  //               });
  //             },
  //             child: Column(
  //               children: <Widget>[
  //                 Padding(
  //                   child: Text(_reserverdTickets[index].ticket.start_destination),
  //                   padding: EdgeInsets.all(10.0),
  //                 ),
  //                 Padding(
  //                   child: Text(_reserverdTickets[index].ticket.stop_destination),
  //                   padding: EdgeInsets.all(10.0),
  //                 ),
  //                 Padding(
  //                   child: Text(_reserverdTickets[index].ticket.expired.toString()),
  //                   padding: EdgeInsets.all(10.0),
  //                 ),
  //                 Padding(
  //                   child:date(_reserverdTickets[index].ticket.date_created),
  //                   padding: EdgeInsets.all(10.0),
  //                 ),
  //                 Padding(
  //                   child: Text(_reserverdTickets[index].ticket.price),
  //                   padding: EdgeInsets.all(10.0),
  //                 ),
  //                 Divider(
  //                   height: 5.0,
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: _reserverdTickets.length,
  //     ),
  //   );
  // }



  void getToken() async
  {
    var ticketDb =await TicketDataBase.ticketDb.getToken();
    _token = ticketDb.access.toString();

  }
  Future<dynamic> fetchUserTickets() {
    _isLoading = true;

    return http
        .get('https://mikail-sauce.herokuapp.com/api/tickets/reserve_ticket',headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    })
        .then((http.Response response) {
      final List<ReservedTickets> fetchedPosts = [];
      // print("Test Data ${response.body.toString()}");

      print("Before Decoding JSON");

      final List<dynamic> postsData = json.decode(response.body);
      print("AFTER Decoding JSON  DATA IS ${postsData.toString()}");
      if (postsData == null) {
        setState(() {
          _isLoading = false;
        });
      }

      for (var i = 0; i < postsData.length; i++) {

        final ReservedTickets reserverdTickets = ReservedTickets(
          ticket: Ticket.fromJson(postsData[i]['ticket'])  ,
            date_purchased:postsData[i]['date_purchased'],
        order_id: postsData[i]['order_id']
        );

        fetchedPosts.add(reserverdTickets);
      }
      setState(() {
        _reserverdTickets = fetchedPosts;
        _isLoading = false;
      });
    }).catchError((Object error) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}


Future<List<ReservedTickets>> fetchReserverdTickets(http.Client client) async {
  // getToken();
  String tt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjEyMDc1NzM0LCJqdGkiOiI3NGQ5ZWI3ZTRlNWY0NDAxYTIxNjczYmRhM2QyZGUzOCIsInVzZXJfaWQiOjV9.ci0_lFtxmG7WC34FxNkVRZQ81ZLOkWLNcqOhHG5Sxrk";
  print("ORDERS SENT ");

  final response =
  await client.get('https://mikail-sauce.herokuapp.com/api/tickets/reserve_ticket',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tt',
      });
  print("ORDERS RECEIVED ${response.body.toString()}");


  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseOrders, response.body);
}

class OrderedTicketList extends StatefulWidget {
  final List<ReservedTickets> tickets;
  OrderedTicketList({Key key, this.tickets}) : super(key: key);

  @override
  _OrderedTicketListState createState() => _OrderedTicketListState();
}

class _OrderedTicketListState extends State<OrderedTicketList> {
  @override
  Widget build(BuildContext context) {
    List<ReservedTickets> _reserverdTickets = widget.tickets;

    return Container(
      child: ListView.builder(
        // _tickets[index].title
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: new InkWell(
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context)
                      .pushNamed('/detail', arguments: _reserverdTickets[index].ticket);
                });
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(_reserverdTickets[index].ticket.start_destination),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_reserverdTickets[index].ticket.stop_destination),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_reserverdTickets[index].ticket.expired.toString()),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child:date(_reserverdTickets[index].ticket.date_created),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    child: Text(_reserverdTickets[index].ticket.price),
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
        itemCount: _reserverdTickets.length,
      ),
    );
  }

  Widget date(String date)
  {
    String formatted = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    return Text(formatted);
  }

}

List<ReservedTickets> parseOrders(String responseBody) {
  print("STARTED PARSING");
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ReservedTickets>((json) => ReservedTickets.fromJson(json)).toList();
}