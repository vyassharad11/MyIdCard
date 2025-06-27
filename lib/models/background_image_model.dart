// To parse this JSON data, do
//
//     final backgroundImageModel = backgroundImageModelFromJson(jsonString);

import 'dart:convert';

BackgroundImageModel backgroundImageModelFromJson(String str) => BackgroundImageModel.fromJson(json.decode(str));

String backgroundImageModelToJson(BackgroundImageModel data) => json.encode(data.toJson());

class BackgroundImageModel {
  bool? status;
  List<BgDatum>? data;

  BackgroundImageModel({
    this.status,
    this.data,
  });

  factory BackgroundImageModel.fromJson(Map<String, dynamic> json) => BackgroundImageModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<BgDatum>.from(json["data"]!.map((x) => BgDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BgDatum {
  int? id;
  String? name;
  String? filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  BgDatum({
    this.id,
    this.name,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  factory BgDatum.fromJson(Map<String, dynamic> json) => BgDatum(
    id: json["id"],
    name: json["name"],
    filePath: json["file_path"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "file_path": filePath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
