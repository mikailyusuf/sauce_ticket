package models

class Delete {
    String email;
    Tokens tokens;
    String username;

    Delete({this.email, this.tokens, this.username});

    factory Delete.fromJson(Map<String, dynamic> json) {
        return Delete(
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