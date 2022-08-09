// To parse this JSON data, do
//
//     final billCodes = billCodesFromJson(jsonString);

import 'dart:convert';

List<BillCodes> billCodesFromJson(String str) =>
    List<BillCodes>.from(json.decode(str).map((x) => BillCodes.fromJson(x)));

String billCodesToJson(List<BillCodes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BillCodes {
  BillCodes({
    this.billCode,
  });

  String? billCode;

  factory BillCodes.fromJson(Map<String, dynamic> json) => BillCodes(
        billCode: json["BillCode"] == null ? null : json["BillCode"],
      );

  Map<String, dynamic> toJson() => {
        "BillCode": billCode == null ? null : billCode,
      };
}
