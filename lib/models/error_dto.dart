import 'dart:convert';

ErrorDto ErrorDtoFromJson(String str) => ErrorDto.fromJson(json.decode(str));

String ErrorDtoToJson(ErrorDto data) => json.encode(data.toJson());

class ErrorDto {

  ErrorDto({
    this.message,
    this.type,
    this.code,
    this.success,
  });

  dynamic? message;
  String? type;
  int? code;
  bool? success;

  factory ErrorDto.fromJson(Map<String, dynamic> json) => ErrorDto(
    message: json["message"],
    type: json["type"],
    code: json["code"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "type": type,
    "code": code,
    "success": success,
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
