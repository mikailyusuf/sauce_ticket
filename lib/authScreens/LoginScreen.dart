import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sauce_ticket/db/localDb.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
import 'package:sauce_ticket/models/LoginModel.dart';
import 'package:sauce_ticket/models/LoginResponse.dart';
import 'package:sauce_ticket/models/Tokens.dart';
import 'package:sauce_ticket/utils/networkStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<LoginResponse> _loginResponse;

  bool isInternet = false;

  void logInUser(bool logged_in) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("logged_in", logged_in);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,

      ),
      body: Form(
        key: _formKey,
        child: (_loginResponse == null)
            ? buildListView(context)
            : FutureBuilder<LoginResponse>(
                future: _loginResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      saveToDb(snapshot.data.tokens);
                      logInUser(true);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (_) => false);
                      });
                    }
                    else{
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Sorry can't Login : ${snapshot.error.toString()}"),
                          duration: Duration(seconds: 1),
                        ));
                      });
                    }
                    return buildListView(context);
                      // return Text("${snapshot.error}");

                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }

  void saveToDb(Tokens tokens) async{
    var ticketDb =await TicketDataBase.ticketDb.insert(tokens);

  }

  ListView buildListView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      children: [
        SizedBox(
          height: 80.0,
        ),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
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
    String username = _emailController.text.toString();
    String password = _passwordController.text.toString();
    LoginModel login = LoginModel(email: username, password: password);

    _loginResponse = loginUser(
        "https://mikail-sauce.herokuapp.com/api/auth/login/",
        body: login.toJson());
  }
}
