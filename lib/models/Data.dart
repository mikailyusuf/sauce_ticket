package models

class Data {
    String email;
    String first_name;
    String last_name;
    String phone_number;
    String username;

    Data({this.email, this.first_name, this.last_name, this.phone_number, this.username});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            email: json['email'], 
            first_name: json['first_name'], 
            last_name: json['last_name'], 
            phone_number: json['phone_number'], 
            username: json['username'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['email'] = this.email;
        data['first_name'] = this.first_name;
        data['last_name'] = this.last_name;
        data['phone_number'] = this.phone_number;
        data['username'] = this.username;
        return data;
    }
}