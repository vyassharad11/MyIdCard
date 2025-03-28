// To parse this JSON data, do
//
//     final signupDto = signupDtoFromJson(jsonString);

import 'dart:convert';

import 'package:my_di_card/models/user_data_model.dart';

SignupDto signupDtoFromJson(String str) => SignupDto.fromJson(json.decode(str));

String signupDtoToJson(SignupDto data) => json.encode(data.toJson());

class SignupDto {
  bool? status;
  String? message;
  User? data;

  SignupDto({
    this.status,
    this.message,
    this.data,
  });

  factory SignupDto.fromJson(Map<String, dynamic> json) => SignupDto(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  dynamic name;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? mode;
  int? userStatusId;
  int? teamId;
  dynamic groupId;
  int? planId;
  int? profile;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic phonenumber;
  dynamic providerId;
  dynamic avatar;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
