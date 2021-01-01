import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
import 'package:sauce_ticket/models/LoginModel.dart';
import 'package:sauce_ticket/models/LoginResponse.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<LoginResponse> _loginResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: (_loginResponse == null)
            ? ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                children: [
                  SizedBox(
                    height: 80.0,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        hintText: 'Enter a your Username'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        hintText: 'Enter a your Password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter  your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  ButtonBar(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/signup',
                          );
                        },
                        child: Text('Sign Up'),
                      ),
                      FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                login();
                              });
                            }
                          },
                          child: Text('Login')),
                    ],
                  )
                ],
              )
            : FutureBuilder<LoginResponse>(
                future: _loginResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.token);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }

  void login() {
    String username = _usernameController.text.toString();
    String password = _passwordController.text.toString();
    LoginModel login = LoginModel(username: username, password: password);
    _loginResponse = loginUser("https://mikail-sauce.herokuapp.com/login/",
        body: login.toMap());
  }
}
