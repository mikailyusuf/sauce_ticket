import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
import 'package:sauce_ticket/models/LoginModel.dart';
import 'package:sauce_ticket/models/LoginResponse.dart';
import 'package:sauce_ticket/networkStatus.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<LoginResponse> _loginResponse;

  bool isInternet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: (_loginResponse == null)
            ? buildListView(context)
            : FutureBuilder<LoginResponse>(
                future: _loginResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    });
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Sorry an error Occured"),
                        duration: Duration(seconds: 1),
                      ));
                    });

                    return buildListView(context);
                    // return Text("${snapshot.error}");
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
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
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    isInternet = await isConnected();
                    if (isInternet) {
                      setState(() {
                        login();
                      });
                    } else {
                      print("Sory yo must be Connected to the Internet");
                    }
                  }
                },
                child: Text('Login')),
          ],
        )
      ],
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
