
class LoginResponse {
    String password;
    String token;
    String user_id;

    LoginResponse({this.password, this.token, this.user_id});

    factory LoginResponse.fromJson(Map<String, dynamic> json) {
        return LoginResponse(
            password: json['password'], 
            token: json['token'], 
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['password'] = this.password;
        data['token'] = this.token;
        data['user_id'] = this.user_id;
        return data;
    }
}