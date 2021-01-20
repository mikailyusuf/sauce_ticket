
class OrderResponse {
    String success;

    OrderResponse({this.success});

    factory OrderResponse.fromJson(Map<String, dynamic> json) {
        return OrderResponse(
            success: json['success'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['success'] = this.success;
        return data;
    }
}