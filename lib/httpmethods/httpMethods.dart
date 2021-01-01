import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sauce_ticket/models/LoginResponse.dart';
import 'package:sauce_ticket/models/RegisterResponse.dart';


Future<LoginResponse> loginUser(String url, {Map body}) async {
  final http.Response response = await http.post(url, body:body).timeout(const Duration(seconds: 60));


  if (response.statusCode == 200) {
    return LoginResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("An Error Occured");
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