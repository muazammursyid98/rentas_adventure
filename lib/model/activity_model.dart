// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

class Activity {
  Activity({
    this.records,
    this.message,
    this.reason,
  });

  List<Record>? records;
  String? message;
  String? reason;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        records: json["records"] == null
            ? null
            : List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        reason: json["reason"] == null ? null : json["reason"],
      );
}

class Record {
  Record({
    this.activityId,
    this.activityName,
    this.activityAvailable,
    this.activityLocation,
    this.activityAsset,
  });

  String? activityId;
  String? activityName;
  String? activityAvailable;
  String? activityLocation;
  String? activityAsset;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        activityId: json["activityId"] == null ? null : json["activityId"],
        activityName:
            json["activityName"] == null ? null : json["activityName"],
        activityAvailable: json["activityAvailable"] == null
            ? null
            : json["activityAvailable"],
        activityLocation:
            json["activityLocation"] == null ? null : json["activityLocation"],
        activityAsset:
            json["activityAsset"] == null ? null : json["activityAsset"],
      );
}
