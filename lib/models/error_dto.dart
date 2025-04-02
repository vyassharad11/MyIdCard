import 'dart:convert';

ErrorDto ErrorDtoFromJson(String str) => ErrorDto.fromJson(json.decode(str));

String ErrorDtoToJson(ErrorDto data) => json.encode(data.toJson());

class ErrorDto {

  ErrorDto({
    this.message,
    this.type,
    this.code,
    this.errors,
    this.success,
  });

  dynamic? message;
  String? type;
  int? code;
  Errors? errors;
  bool? success;

  factory ErrorDto.fromJson(Map<String, dynamic> json) => ErrorDto(
    message: json["message"],
    type: json["type"],
    code: json["code"],
    success: json["success"],
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "type": type,
    "code": code,
    "success": success,
    "errors": errors?.toJson(),
  };
}

class Errors {
  List<String>? emailVerificationCode;

  Errors({
    this.emailVerificationCode,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    emailVerificationCode: json["email_verification_code"] == null ? [] : List<String>.from(json["email_verification_code"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "email_verification_code": emailVerificationCode == null ? [] : List<dynamic>.from(emailVerificationCode!.map((x) => x)),
  };
}

class Result {
  Result({
    this.id,
    this.message,

  });

  int? id;
  String? message;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
  };
}
