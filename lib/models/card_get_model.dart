// To parse this JSON data, do
//
//     final getCardModel = getCardModelFromJson(jsonString);

import 'dart:convert';

GetCardModel getCardModelFromJson(String str) => GetCardModel.fromJson(json.decode(str));

String getCardModelToJson(GetCardModel data) => json.encode(data.toJson());

class GetCardModel {
  bool? status;
  String? message;
  Data? data;

  GetCardModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetCardModel.fromJson(Map<String, dynamic> json) => GetCardModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? userId;
  int? languageId;
  String? cardImage;
  String? firstName;
  String? lastName;
  String? companyName;
  dynamic companyLogo;
  int? companyTypeId;
  String? jobTitle;
  String? companyAddress;
  String? companyWebsite;
  String? workEmail;
  String? phoneNo;
  String? cardStyle;
  dynamic backgroungImage;
  String? cardName;
  String? stepNo;
  dynamic notes;
  String? qrCode;
  int? cardTypeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<CardDocuments>? cardDocuments;
  List<CardSocial>? cardSocials;
  CompanyType? companyType;

  Data({
    this.id,
    this.userId,
    this.languageId,
    this.cardImage,
    this.firstName,
    this.lastName,
    this.companyName,
    this.companyLogo,
    this.companyTypeId,
    this.jobTitle,
    this.companyAddress,
    this.companyWebsite,
    this.workEmail,
    this.phoneNo,
    this.cardStyle,
    this.backgroungImage,
    this.cardName,
    this.stepNo,
    this.notes,
    this.qrCode,
    this.cardTypeId,
    this.createdAt,
    this.updatedAt,
    this.cardDocuments,
    this.cardSocials,
    this.companyType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    languageId: json["language_id"],
    cardImage: json["card_image"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    companyName: json["company_name"],
    companyLogo: json["company_logo"],
    companyTypeId: json["company_type_id"],
    jobTitle: json["job_title"],
    companyAddress: json["company_address"],
    companyWebsite: json["company_website"],
    workEmail: json["work_email"],
    phoneNo: json["phone_no"],
    cardStyle: json["card_style"],
    backgroungImage: json["backgroung_image"],
    cardName: json["card_name"],
    stepNo: json["step_no"],
    notes: json["notes"],
    qrCode: json["qr_code"],
    cardTypeId: json["card_type_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    cardDocuments: json["cardDocuments"] == null ? [] : List<CardDocuments>.from(json["cardDocuments"]!.map((x) => CardDocuments.fromJson(x))),
    cardSocials: json["cardSocials"] == null ? [] : List<CardSocial>.from(json["cardSocials"]!.map((x) => CardSocial.fromJson(x))),
    companyType: json["company_type"] == null ? null : CompanyType.fromJson(json["company_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "language_id": languageId,
    "card_image": cardImage,
    "first_name": firstName,
    "last_name": lastName,
    "company_name": companyName,
    "company_logo": companyLogo,
    "company_type_id": companyTypeId,
    "job_title": jobTitle,
    "company_address": companyAddress,
    "company_website": companyWebsite,
    "work_email": workEmail,
    "phone_no": phoneNo,
    "card_style": cardStyle,
    "backgroung_image": backgroungImage,
    "card_name": cardName,
    "step_no": stepNo,
    "notes": notes,
    "qr_code": qrCode,
    "card_type_id": cardTypeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cardDocuments": cardDocuments == null ? [] : List<dynamic>.from(cardDocuments!.map((x) => x.toJson())),
    "cardSocials": cardSocials == null ? [] : List<dynamic>.from(cardSocials!.map((x) => x.toJson())),
    "company_type": companyType?.toJson(),
  };
}

class CardSocial {
  int? id;
  int? cardId;
  int? socialId;
  String? socialLink;
  String? socialName;
  String? socialLogo;
  String? socialUrl;

  CardSocial({
    this.id,
    this.cardId,
    this.socialId,
    this.socialLink,
    this.socialName,
    this.socialLogo,
    this.socialUrl,
  });

  factory CardSocial.fromJson(Map<String, dynamic> json) => CardSocial(
    id: json["id"],
    cardId: json["card_id"],
    socialId: json["social_id"],
    socialLink: json["social_link"],
    socialName: json["social_name"],
    socialLogo: json["social_logo"],
    socialUrl: json["social_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "card_id": cardId,
    "social_id": socialId,
    "social_link": socialLink,
    "social_name": socialName,
    "social_logo": socialLogo,
    "social_url": socialUrl,
  };
}

class CompanyType {
  int? id;
  String? companyType;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  CompanyType({
    this.id,
    this.companyType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CompanyType.fromJson(Map<String, dynamic> json) => CompanyType(
    id: json["id"],
    companyType: json["company_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_type": companyType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}

class CardDocuments {
  int? id;
  dynamic cardId;
  dynamic document;
  dynamic documentsName;

  CardDocuments({this.id, this.cardId, this.document,this.documentsName});

  CardDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['card_id'];
    documentsName = json['documentsName'];
    document = json['document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['card_id'] = cardId;
    data['document'] = document;
    data['documentsName'] = documentsName;
    return data;
  }
}

class CardSocials {
  int? id;
  dynamic cardId;
  dynamic socialId;
  dynamic socialLink;
  dynamic socialName;
  dynamic socialLogo;
  dynamic socialUrl;

  CardSocials(
      {this.id,
        this.cardId,
        this.socialId,
        this.socialLink,
        this.socialName,
        this.socialUrl,
        this.socialLogo});

  CardSocials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['card_id'];
    socialId = json['social_id'];
    socialLink = json['social_link'];
    socialUrl = json['social_url'];
    socialName = json['social_name'];
    socialLogo = json['social_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['card_id'] = cardId;
    data['social_id'] = socialId;
    data['social_url'] = socialUrl;
    data['social_link'] = socialLink;
    data['social_name'] = socialName;
    data['social_logo'] = socialLogo;
    return data;
  }
}
