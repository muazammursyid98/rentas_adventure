// To parse this JSON data, do
//
//     final listSessionRecords = listSessionRecordsFromJson(jsonString);

import 'dart:convert';

ListSessionRecords listSessionRecordsFromJson(String str) =>
    ListSessionRecords.fromJson(json.decode(str));

String listSessionRecordsToJson(ListSessionRecords data) =>
    json.encode(data.toJson());

class ListSessionRecords {
  ListSessionRecords({
    this.listSessionRecords,
    this.message,
    this.reason,
  });

  List<ListSessionRecord>? listSessionRecords;
  String? message;
  String? reason;

  factory ListSessionRecords.fromJson(Map<String, dynamic> json) =>
      ListSessionRecords(
        listSessionRecords: List<ListSessionRecord>.from(
            json["listSessionRecords"]
                .map((x) => ListSessionRecord.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "listSessionRecords":
            List<dynamic>.from(listSessionRecords!.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class ListSessionRecord {
  ListSessionRecord(
      {this.activitiesSessionId,
      this.activitiesId,
      this.shiftActivitiesId,
      this.timeDescription,
      this.shiftName});

  String? activitiesSessionId;
  String? activitiesId;
  String? shiftActivitiesId;
  String? timeDescription;
  String? shiftName;

  factory ListSessionRecord.fromJson(Map<String, dynamic> json) =>
      ListSessionRecord(
        activitiesSessionId: json["activitiesSessionId"],
        activitiesId: json["activitiesId"],
        shiftActivitiesId: json["shiftActivitiesId"],
        timeDescription:
            json["timeDescription"] == null || json["timeDescription"] == ""
                ? ""
                : Uri.decodeComponent(json["timeDescription"]),
        shiftName: json["shiftName"],
      );

  Map<String, dynamic> toJson() => {
        "activitiesSessionId": activitiesSessionId,
        "activitiesId": activitiesId,
        "shiftActivitiesId": shiftActivitiesId,
        "timeDescription": timeDescription,
      };
}
