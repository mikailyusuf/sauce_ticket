
class RegisterModel {
    String email;
    String first_name;
    String last_name;
    String password;
    String phone_number;
    String username;

    RegisterModel({this.email, this.first_name, this.last_name, this.password, this.phone_number, this.username});

    factory RegisterModel.fromJson(Map<String, dynamic> json) {
        return RegisterModel(
            email: json['email'], 
            first_name: json['first_name'], 
            last_name: json['last_name'], 
            password: json['password'], 
            phone_number: json['phone_number'], 
            username: json['username'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['email'] = this.email;
        data['first_name'] = this.first_name;
        data['last_name'] = this.last_name;
        data['password'] = this.password;
        data['phone_number'] = this.phone_number;
        data['username'] = this.username;
        return data;
    }
}