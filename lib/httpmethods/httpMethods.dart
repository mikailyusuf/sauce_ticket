import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sauce_ticket/models/LoginResponse.dart';
import 'package:sauce_ticket/models/OrderResponse.dart';
import 'package:sauce_ticket/models/RegisterResponse.dart';


Future<LoginResponse> loginUser(String url, {Map body}) async {

  try
  {
    final http.Response response = await http.post(url, body:body).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("An Error Occured");
    }
  }
  catch (e)
  {
  }
}

Future<RegisterResponse> registerUser(String url, {Map body}) async {
  final http.Response response = await http.post(url, body:body).timeout(const Duration(seconds: 60));
  if (response.statusCode == 201) {
    return RegisterResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("An Error Occured");
  }
}



Future<OrderResponse> makeTicketOrder(String url,String token, {Map body}) async {
  final http.Response response = await http.post(url, body:body,headers:{
    HttpHeaders.authorizationHeader: 'Bearer $token',
  } ).timeout(const Duration(seconds: 60));
  if (response.statusCode == 200) {
    return OrderResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("An Error Occured");
  }
}