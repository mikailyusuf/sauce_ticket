
class TicketsModel {
    String date_created;
    bool expired;
    int id;
    String price;
    String start_destination;
    String stop_destination;
    String ticket_id;
    bool used;

    TicketsModel({this.date_created, this.expired, this.id, this.price, this.start_destination, this.stop_destination, this.ticket_id, this.used});

    factory TicketsModel.fromJson(Map<String, dynamic> json) {
        return TicketsModel(
            date_created: json['date_created'], 
            expired: json['expired'], 
            id: json['id'], 
            price: json['price'], 
            start_destination: json['start_destination'], 
            stop_destination: json['stop_destination'], 
            ticket_id: json['ticket_id'], 
            used: json['used'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date_created'] = this.date_created;
        data['expired'] = this.expired;
        data['id'] = this.id;
        data['price'] = this.price;
        data['start_destination'] = this.start_destination;
        data['stop_destination'] = this.stop_destination;
        data['ticket_id'] = this.ticket_id;
        data['used'] = this.used;
        return data;
    }
}