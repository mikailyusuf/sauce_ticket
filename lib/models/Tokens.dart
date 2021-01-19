
class Tokens {
    String access;
    String refresh;

    Tokens({this.access, this.refresh});

    factory Tokens.fromJson(Map<String, dynamic> json) {
        return Tokens(
            access: json['Access'],
            refresh: json['Refresh'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['access'] = this.access;
        data['refresh'] = this.refresh;
        return data;
    }
}