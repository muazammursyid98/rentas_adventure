// To parse this JSON data, do
//
//     final listOrder = listOrderFromJson(jsonString);

import 'dart:convert';

ListOrder listOrderFromJson(String str) => ListOrder.fromJson(json.decode(str));

String listOrderToJson(ListOrder data) => json.encode(data.toJson());

class ListOrder {
  ListOrder({
    this.records,
    this.name,
    this.phoneNumber,
    this.invoiceNumber,
    this.emailCustomer,
    this.totalPrice,
    this.orderTime,
    this.listOrder,
    this.message,
    this.reason,
  });

  String? records;
  String? name;
  String? phoneNumber;
  String? invoiceNumber;
  String? emailCustomer;
  String? totalPrice;
  String? orderTime;
  List<ListOrderElement>? listOrder;
  String? message;
  String? reason;

  factory ListOrder.fromJson(Map<String, dynamic> json) => ListOrder(
        records: json["records"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        invoiceNumber: json["invoice_number"],
        emailCustomer: json["emailCustomer"],
        totalPrice: json["totalPrice"],
        orderTime: json["orderTime"],
        listOrder: List<ListOrderElement>.from(
            json["listOrder"].map((x) => ListOrderElement.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "records": records,
        "name": name,
        "phoneNumber": phoneNumber,
        "invoice_number": invoiceNumber,
        "emailCustomer": emailCustomer,
        "listOrder": List<dynamic>.from(listOrder!.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class ListOrderElement {
  ListOrderElement({
    this.activityId,
    this.activityName,
    this.totalBookedSlot,
    this.totalPrice,
    this.shiftName,
  });

  String? activityId;
  String? activityName;
  String? totalBookedSlot;
  String? totalPrice;
  String? shiftName;

  factory ListOrderElement.fromJson(Map<String, dynamic> json) =>
      ListOrderElement(
        activityId: json["activityId"],
        activityName: json["activityName"],
        totalBookedSlot: json["totalBookedSlot"],
        totalPrice: json["totalPrice"],
        shiftName: json["shiftName"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityName": activityName,
        "totalBookedSlot": totalBookedSlot,
        "totalPrice": totalPrice,
        "shiftName": shiftName,
      };
}
