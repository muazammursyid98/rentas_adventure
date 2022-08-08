// To parse this JSON data, do
//
//     final sessionTime = sessionTimeFromJson(jsonString);

import 'dart:convert';

SessionTime sessionTimeFromJson(String str) =>
    SessionTime.fromJson(json.decode(str));

String sessionTimeToJson(SessionTime data) => json.encode(data.toJson());

class SessionTime {
  SessionTime({
    this.records,
    this.message,
    this.reason,
  });

  List<Session>? records;
  String? message;
  String? reason;

  factory SessionTime.fromJson(Map<String, dynamic> json) => SessionTime(
        records: json["records"] == null
            ? null
            : List<Session>.from(
                json["records"].map((x) => Session.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "records": records == null
            ? null
            : List<dynamic>.from(records!.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class Session {
  Session({
    this.shiftId,
    this.shiftName,
    this.startTime,
    this.endTime,
  });

  int? shiftId;
  String? shiftName;
  String? startTime;
  String? endTime;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        shiftId: int.parse(json["shiftId"]),
        shiftName: json["shiftName"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "shiftId": shiftId,
        "shiftName": shiftName,
        "startTime": startTime,
        "endTime": endTime,
      };
}
