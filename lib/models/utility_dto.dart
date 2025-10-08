import 'dart:convert';

UtilityDto UtilityDtoFromJson(String str) => UtilityDto.fromJson(json.decode(str));

String UtilityDtoToJson(UtilityDto data) => json.encode(data.toJson());

class UtilityDto {

  UtilityDto({
    this.result,
    this.message,
    this.token,
    this.url,
    this.id,
    this.urlFr,
  });

  Result? result;
  String? message;
  String? token;
  String? url;
  String? urlFr;
  dynamic id;

  factory UtilityDto.fromJson(Map<String, dynamic> json) => UtilityDto(
    result:
    json.containsKey("result") ? Result.fromJson(json["result"]) : null,
    message: json["message"],
    url: json["url"],
    token: json["token"],
    urlFr: json["url_fr"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "result": result != null ? result?.toJson() : null,
    "message": message,
    "url": url,
    "url_fr": urlFr,
    "id": id,
    "token": token,
  };
}

class Result {
  Result({
    this.id,
    this.message,
    this.token,
  });

  dynamic? id;
  String? message;
  String? token;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "token": token,
  };
}
