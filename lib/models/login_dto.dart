// To parse this JSON data, do
//
//     final loginDto = loginDtoFromJson(jsonString);

import 'dart:convert';

import 'package:my_di_card/models/user_data_model.dart';

LoginDto loginDtoFromJson(String str) => LoginDto.fromJson(json.decode(str));

String loginDtoToJson(LoginDto data) => json.encode(data.toJson());

class LoginDto {
  bool? status;
  String? message;
  String? token;
  User? user;

  LoginDto({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
    status: json["status"],
    message: json["message"],
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "token": token,
    "user": user?.toJson(),
  };
}


