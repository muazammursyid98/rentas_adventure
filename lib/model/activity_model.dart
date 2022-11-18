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
        message: json["message"],
        reason: json["reason"],
      );
}

class Record {
  Record({
    this.activityId,
    this.activityName,
    this.activityAvailable,
    this.activityLocation,
    this.activityAsset,
    this.activityPrice,
  });

  String? activityId;
  String? activityName;
  String? activityAvailable;
  String? activityLocation;
  String? activityAsset;
  String? activityPrice;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        activityId: json["activityId"],
        activityName: json["activityName"],
        activityAvailable: json["activityAvailable"],
        activityLocation: json["activityLocation"],
        activityAsset: json["activityAsset"],
        activityPrice: json["activityPrice"],
      );
}
