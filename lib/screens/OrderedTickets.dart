import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sauce_ticket/models/TicketsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedTickets extends StatefulWidget {
  @override
  _SavedTicketsState createState() => _SavedTicketsState();
}

class _SavedTicketsState extends State<SavedTickets> {
  List<TicketsModel> _tickets = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  int user_id;

  @override
  initState() {
    super.initState();
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
      body:_isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildTicketList() ,
    );
  }

  Future<dynamic> _onRefresh() {
    return fetchUserTickets();
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

  Future<dynamic> fetchUserTickets() {
    _isLoading = true;

    return http
        .get('https://mikail-sauce.herokuapp.com/get_ticket/${user_id}/')
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
