// To parse this JSON data, do
//
//     final groupMember = groupMemberFromJson(jsonString);

import 'dart:convert';

GroupMember groupMemberFromJson(String str) => GroupMember.fromJson(json.decode(str));

String groupMemberToJson(GroupMember data) => json.encode(data.toJson());

class GroupMember {
  bool? status;
  List<MemberDatum>? data;

  GroupMember({
    this.status,
    this.data,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    status: json["status"],
    data: json["data"] == null ? [] : List<MemberDatum>.from(json["data"]!.map((x) => MemberDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MemberDatum {
  int? id;
  dynamic name;
  dynamic firstName;
  dynamic lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? mode;
  int? userStatusId;
  dynamic teamId;
  int? groupId;
  int? planId;
  int? profile;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic phonenumber;
  dynamic providerId;
  dynamic avatar;

  MemberDatum({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.mode,
    this.userStatusId,
    this.teamId,
    this.groupId,
    this.planId,
    this.profile,
    this.createdAt,
    this.updatedAt,
    this.phonenumber,
    this.providerId,
    this.avatar,
  });

  factory MemberDatum.fromJson(Map<String, dynamic> json) => MemberDatum(
    id: json["id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    mode: json["mode"],
    userStatusId: json["user_status_id"],
    teamId: json["team_id"],
    groupId: json["group_id"],
    planId: json["plan_id"],
    profile: json["profile"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    phonenumber: json["phonenumber"],
    providerId: json["provider_id"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "mode": mode,
    "user_status_id": userStatusId,
    "team_id": teamId,
    "group_id": groupId,
    "plan_id": planId,
    "profile": profile,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "phonenumber": phonenumber,
    "provider_id": providerId,
    "avatar": avatar,
  };
}
