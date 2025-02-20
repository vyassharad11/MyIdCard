// To parse this JSON data, do
//
//     final myGroupListModel = myGroupListModelFromJson(jsonString);

import 'dart:convert';

MyGroupListModel myGroupListModelFromJson(String str) => MyGroupListModel.fromJson(json.decode(str));

String myGroupListModelToJson(MyGroupListModel data) => json.encode(data.toJson());

class MyGroupListModel {
  bool? status;
  List<MyGroupListDatum>? data;

  MyGroupListModel({
    this.status,
    this.data,
  });

  factory MyGroupListModel.fromJson(Map<String, dynamic> json) => MyGroupListModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<MyGroupListDatum>.from(json["data"]!.map((x) => MyGroupListDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MyGroupListDatum {
  int? id;
  int? teamId;
  dynamic adminId;
  String? groupName;
  String? groupDescription;
  dynamic groupLogo;

  MyGroupListDatum({
    this.id,
    this.teamId,
    this.adminId,
    this.groupName,
    this.groupDescription,
    this.groupLogo,
  });

  factory MyGroupListDatum.fromJson(Map<String, dynamic> json) => MyGroupListDatum(
    id: json["id"],
    teamId: json["team_id"],
    adminId: json["admin_id"],
    groupName: json["group_name"],
    groupDescription: json["group_description"],
    groupLogo: json["group_logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_id": teamId,
    "admin_id": adminId,
    "group_name": groupName,
    "group_description": groupDescription,
    "group_logo": groupLogo,
  };
}
