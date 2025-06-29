// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  bool? success;
  List<NotificationDatum>? data;
  Meta? meta;

  NotificationModel({
    this.success,
    this.data,
    this.meta,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<NotificationDatum>.from(json["data"]!.map((x) => NotificationDatum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class NotificationDatum {
  int? id;
  int? userId;
  String? title;
  String? message;
  String? type;
  DateTime? sentAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationDatum({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationDatum.fromJson(Map<String, dynamic> json) => NotificationDatum(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    message: json["message"],
    type: json["type"],
    sentAt: json["sent_at"] == null ? null : DateTime.parse(json["sent_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "message": message,
    "type": type,
    "sent_at": sentAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Meta {
  int? total;
  int? limit;
  int? offset;

  Meta({
    this.total,
    this.limit,
    this.offset,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    limit: json["limit"],
    offset: json["offset"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "offset": offset,
  };
}
