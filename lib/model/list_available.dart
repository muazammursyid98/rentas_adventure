// To parse this JSON data, do
//
//     final listAvailable = listAvailableFromJson(jsonString);

import 'dart:convert';

ListAvailable listAvailableFromJson(String str) =>
    ListAvailable.fromJson(json.decode(str));

String listAvailableToJson(ListAvailable data) => json.encode(data.toJson());

class ListAvailable {
  ListAvailable({
    this.listAvailable,
    this.message,
    this.reason,
  });

  List<ListAvailableElement>? listAvailable;
  String? message;
  String? reason;

  factory ListAvailable.fromJson(Map<String, dynamic> json) => ListAvailable(
        listAvailable: List<ListAvailableElement>.from(
            json["listAvailable"].map((x) => ListAvailableElement.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "listAvailable":
            List<dynamic>.from(listAvailable!.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class ListAvailableElement {
  ListAvailableElement({
    this.purchased,
    this.shiftSlotId,
  });

  String? purchased;
  String? shiftSlotId;

  factory ListAvailableElement.fromJson(Map<String, dynamic> json) =>
      ListAvailableElement(
        purchased: json["purchased"],
        shiftSlotId: json["shiftSlotId"],
      );

  Map<String, dynamic> toJson() => {
        "purchased": purchased,
        "shiftSlotId": shiftSlotId,
      };
}
