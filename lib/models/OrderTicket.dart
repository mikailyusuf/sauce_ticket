
class OrderTicket {
    int ticket_id;

    OrderTicket({this.ticket_id});

    factory OrderTicket.fromJson(Map<String, dynamic> json) {
        return OrderTicket(
            ticket_id: json['ticket_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ticket_id'] = this.ticket_id;
        return data;
    }
}