// To parse this JSON data, do
//
//     final tagModel = tagModelFromJson(jsonString);

import 'dart:convert';

TagModel tagModelFromJson(String str) => TagModel.fromJson(json.decode(str));

String tagModelToJson(TagModel data) => json.encode(data.toJson());

class TagModel {
  bool? status;
  List<TagDatum>? data;

  TagModel({
    this.status,
    this.data,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<TagDatum>.from(json["data"]!.map((x) => TagDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TagDatum {
  int? id;
  String? tag;
  int? teamId;

  TagDatum({
    this.id,
    this.tag,
    this.teamId,
  });

  factory TagDatum.fromJson(Map<String, dynamic> json) => TagDatum(
    id: json["id"],
    tag: json["tag"],
    teamId: json["team_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag": tag,
    "team_id": teamId,
  };
}
