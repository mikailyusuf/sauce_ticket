
class SavedUserTokens {
    String access;
    String refresh;

    SavedUserTokens({this.access, this.refresh});

    factory SavedUserTokens.fromJson(Map<String, dynamic> json) {
        return SavedUserTokens(
            access: json['Access'],
            refresh: json['Refresh'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Access'] = this.access;
        data['Refresh'] = this.refresh;
        return data;
    }
}