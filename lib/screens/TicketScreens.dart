import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sauce_ticket/db/localDb.dart';
import 'package:sauce_ticket/models/TicketsModel.dart';
import 'package:http/http.dart' as http;
import 'package:sauce_ticket/models/Tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketScreen extends StatefulWidget {

  Tokens token;
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<TicketsModel> _tickets = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;


  @override
  initState() {
    super.initState();
    getTickets();
    fetchTickets();
  }

  void getTickets() async
  {
    var ticketDb =await TicketDataBase.ticketDb.getToken();
    print("THIS ARE THE TOKENS  ${ticketDb.access.toString()}  ${ticketDb.refresh.toString()}");
    // var del =await TicketDataBase.ticketDb.delete();


  }






  LogOut(bool logged_in,) async {
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
              )
          ),
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
                  print("CARD CLICKED");
                  print(_tickets[index].toString());
                  Navigator.of(context)
                      .pushNamed('/detail', arguments: _tickets[index]);
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

  Future<dynamic> fetchTickets() {
    _isLoading = true;

    return http
        .get('https://mikail-sauce.herokuapp.com/list_tickets/')
        .then((http.Response response) {
      final List<TicketsModel> fetchedPosts = [];

      final List<dynamic> postsData = json.decode(response.body);
      if (postsData == null) {
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
        _isLoading = false;
      });
    }).catchError((Object error) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}

