
import 'Ticket.dart';

class ReservedTickets {
    String date_purchased;
    String order_id;
    Ticket ticket;

    ReservedTickets({this.date_purchased, this.order_id, this.ticket});

    factory ReservedTickets.fromJson(Map<String, dynamic> json) {
        return ReservedTickets(
            date_purchased: json['date_purchased'], 
            order_id: json['order_id'], 
            ticket: json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date_purchased'] = this.date_purchased;
        data['order_id'] = this.order_id;
        if (this.ticket != null) {
            data['ticket'] = this.ticket.toJson();
        }
        return data;
    }
}