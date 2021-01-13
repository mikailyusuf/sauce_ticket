
import 'Tokens.dart';

class LoginResponse {
    String email;
    Tokens tokens;
    String username;

    LoginResponse({this.email, this.tokens, this.username});

    factory LoginResponse.fromJson(Map<String, dynamic> json) {
        return LoginResponse(
            email: json['email'], 
            tokens: json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null, 
            username: json['username'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['email'] = this.email;
        data['username'] = this.username;
        if (this.tokens != null) {
            data['tokens'] = this.tokens.toJson();
        }
        return data;
    }
}