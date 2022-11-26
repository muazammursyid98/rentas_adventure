// To parse this JSON data, do
//
//     final imageDetails = imageDetailsFromJson(jsonString);

import 'dart:convert';

ImageDetails imageDetailsFromJson(String str) =>
    ImageDetails.fromJson(json.decode(str));

String imageDetailsToJson(ImageDetails data) => json.encode(data.toJson());

class ImageDetails {
  ImageDetails({
    this.imageDetails,
    this.message,
    this.reason,
  });

  List<ImageDetail>? imageDetails;
  String? message;
  String? reason;

  factory ImageDetails.fromJson(Map<String, dynamic> json) => ImageDetails(
        imageDetails: List<ImageDetail>.from(
            json["imageDetails"].map((x) => ImageDetail.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "imageDetails":
            List<dynamic>.from(imageDetails!.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class ImageDetail {
  ImageDetail({
    this.activitiesDetailsId,
    this.activitiesId,
    this.imageName,
    this.createdDate,
  });

  String? activitiesDetailsId;
  String? activitiesId;
  String? imageName;
  DateTime? createdDate;

  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        activitiesDetailsId: json["activitiesDetailsId"],
        activitiesId: json["activitiesId"],
        imageName: json["imageName"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "activitiesDetailsId": activitiesDetailsId,
        "activitiesId": activitiesId,
        "imageName": imageName,
        "createdDate":
            "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
      };
}
