import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sauce_ticket/db/localDb.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
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
  List<TicketsModel> _tickets = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    getToken();
    fetchTickets();
  }

  void getToken() async {
    var ticketDb = await TicketDataBase.ticketDb.getToken();
    _token = ticketDb.access.toString();
  }

  void deleteToken() async {
    var del = await TicketDataBase.ticketDb.delete();
  }

  LogOut(
    bool logged_in,
  ) async {
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
                  LogOut(true);
                  setState(() {
                    deleteToken();
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildTicketList(),
    );
  }

  Future<dynamic> _onRefresh() {
    return fetchTickets();
  }

  Widget _buildTicketList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      key: _refreshIndicatorKey,
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
                    child: Text(_tickets[index].date_created),
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

  Widget date(String date)
  {
    // var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    // var inputDate = inputFormat.parse(date); // <-- Incoming date
    //
    // var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate); // <-- Desired date
    // print(outputDate);
    String formatted = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    return Text(formatted);
  }
  
  Future<dynamic> orderTicket(int id) {
    _isLoading = true;
    OrderTicket order = OrderTicket(ticket_id: id);
    String url =
        "https://mikail-sauce.herokuapp.com/api/tickets/reserve_ticket";

    return http.post(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },body:  jsonEncode(<String, int>{
      'ticket_id': id,
    })).then((http.Response response) {
      print("The Response body ${response.body.toString()} ");

      final OrderResponse orderResponse = json.decode(response.body);
      if (orderResponse == null) {
        print("POST DATA IS NULL");

        setState(() {
          _isLoading = false;
        });
      }

      print("RESPONSE  $orderResponse");

      setState(() {
        _isLoading = false;

        // _tickets = fetchedPosts;

      });
    }).catchError((Object error) {
      print("AN ERROR OCCURED ${error.toString()}");

      setState(() {
        _isLoading = false;
      });
    });

  }

  Future<dynamic> fetchTickets() {
    _isLoading = true;

    return http.get(
        'https://mikail-sauce.herokuapp.com/api/tickets/get_tickets',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
        }).then((http.Response response) {
      // print("The Response body ${response.body.toString()} ");
      final List<TicketsModel> fetchedPosts = [];

      final List<dynamic> postsData = json.decode(response.body);
      if (postsData == null) {
        print("POST DATA IS NULL");

        setState(() {
          _isLoading = false;
        });
      }

      for (var i = 0; i < postsData.length; i++) {
        final TicketsModel tickets = TicketsModel(
            start_destination: postsData[i]['start_destination'],
            id: postsData[i]['id'],
            stop_destination: postsData[i]['stop_destination'],
            expired: postsData[i]['expired'],
            date_created: postsData[i]['date_created'],
            ticket_id: postsData[i]['ticket_id'],
            used: postsData[i]['used'],
            price: postsData[i]['price']);

        fetchedPosts.add(tickets);
      }
      setState(() {
        _tickets = fetchedPosts;
        // print("THESE ARE THE DATAS ${_tickets.toString()}");
        _isLoading = false;
      });
    }).catchError((Object error) {
      // print("AN ERROR OCCURED ${error.toString()}");

      setState(() {
        _isLoading = false;
      });
    });
  }
}
