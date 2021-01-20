import 'package:flutter/material.dart';
import 'package:sauce_ticket/httpmethods/httpMethods.dart';
import 'package:sauce_ticket/models/RegisterModel.dart';
import 'package:sauce_ticket/models/RegisterResponse.dart';
import 'package:sauce_ticket/utils/networkStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<RegisterResponse> _registerResponse;

  bool isInternet = false;

  saveUserData(bool logged_in, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("logged_in", logged_in);
      // prefs.setString("email", email);
    });
  }

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
                  if(snapshot.connectionState == ConnectionState.done)
                    {

                      if (snapshot.hasData) {

                        WidgetsBinding.instance.addPostFrameCallback((_) {

                          String email = snapshot.data.email;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("${email}  Has been registered Pls Check your mail to Verify Your Account"),
                            duration: Duration(seconds: 1),
                          ));

                          Navigator.pushNamedAndRemoveUntil(context,'/login',(_)=>false);


                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //   content: Text("Successfully Registered"),
                          //   duration: Duration(seconds: 10),
                          //
                          // ));

                        });
                      } else if (snapshot.hasError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Sorry an error Occured"),
                            duration: Duration(seconds: 1),
                          ));
                        });

                        return buildListView();
                      }
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
        SizedBox(height: 18.0,),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: _phoneNumberController,
          decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              hintText: 'Enter a your Phone Number'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
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
                onPressed: ()  async {
                  if (_formKey.currentState.validate()) {
                    isInternet = await isConnected();
                    if(isInternet)
                      {
                        setState(() {
                          register();
                        });
                      }
                    else{
                      print("Sory yo must be Connected to the Internet");
                    }

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
    String phone_number = _phoneNumberController.text.toString();


    RegisterModel registerModel = RegisterModel(
        username: username,
        password: password,
        email: email,
        first_name: first_name,
        phone_number: phone_number,
        last_name: last_name);


          _registerResponse = registerUser(
                  "https://mikail-sauce.herokuapp.com/api/auth/register",
                  body: registerModel.toJson());
    // saveUserData(true,registerModel.email);



  }

}
