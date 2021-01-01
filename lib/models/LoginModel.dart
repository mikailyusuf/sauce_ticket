
class LoginModel{
  final String username;
  final String password;

  LoginModel({this.username,this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      username: json['user_id'],
      password: json['password'],

    );
  }

  Map toMap() {
    var map = new Map();
    map["user_id"] = username;
    map["password"] = password;
    return map;
  }

}