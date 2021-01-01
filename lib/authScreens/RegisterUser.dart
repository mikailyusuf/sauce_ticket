import 'package:flutter/material.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
import 'package:sauce_ticket/models/RegisterModel.dart';
import 'package:sauce_ticket/models/RegisterResponse.dart';

import 'TicketScreens.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<RegisterResponse> _registerResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: (_registerResponse == null)
            ? buildListView()
            : FutureBuilder<RegisterResponse>(
                future: _registerResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Successfully Registered"),
                        duration: Duration(seconds: 10),
                      ));
                    });
                    Navigator.of(context).pushNamed('/home',);
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Sorry an error Occured"),
                        duration: Duration(seconds: 1),
                      ));
                    });

                    return buildListView();
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }

  ListView buildListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      children: [
        SizedBox(
          height: 80.0,
        ),
        TextFormField(
          controller: _firstnameController,
          decoration: InputDecoration(
              labelText: 'Firstname',
              border: OutlineInputBorder(),
              hintText: 'Enter a your Firstname'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        SizedBox(height: 18.0),
        TextFormField(
          controller: _lastnameController,
          decoration: InputDecoration(
              labelText: 'Lastname',
              border: OutlineInputBorder(),
              hintText: 'Enter a your Lastname'),
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
        TextFormField(
          keyboardType: TextInputType.text,
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
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              hintText: 'Enter a your Email'),
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
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              hintText: 'Enter a your Password'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
                color: Colors.teal,
                child: Text(
                  "SIGN UP",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      register();
                    });
                  }
                })
          ],
        )
      ],
    );
  }

  void register() {
    String username = _usernameController.text.toString();
    String email = _emailController.text.toString();
    String first_name = _firstnameController.text.toString();
    String last_name = _lastnameController.text.toString();
    String password = _passwordController.text.toString();
    RegisterModel registerModel = RegisterModel(
        username: username,
        password: password,
        email: email,
        first_name: first_name,
        last_name: last_name);
    _registerResponse = registerUser(
        "https://mikail-sauce.herokuapp.com/register_user/",
        body: registerModel.toJson());
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
