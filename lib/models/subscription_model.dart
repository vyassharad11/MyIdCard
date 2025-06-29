// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
  bool? status;
  List<SubscriptionDatum>? data;

  SubscriptionModel({
    this.status,
    this.data,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<SubscriptionDatum>.from(json["data"]!.map((x) => SubscriptionDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SubscriptionDatum {
  int? id;
  String? planName;
  String? discription;
  int? validity;
  int? price;
  int? noOfCard;
  int? noOfMember;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubscriptionDatum({
    this.id,
    this.planName,
    this.discription,
    this.validity,
    this.price,
    this.noOfCard,
    this.noOfMember,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionDatum.fromJson(Map<String, dynamic> json) => SubscriptionDatum(
    id: json["id"],
    planName: json["plan_name"],
    discription: json["discription"],
    validity: json["validity"],
    price: json["price"],
    noOfCard: json["no_of_card"],
    noOfMember: json["no_of_member"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_name": planName,
    "discription": discription,
    "validity": validity,
    "price": price,
    "no_of_card": noOfCard,
    "no_of_member": noOfMember,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
