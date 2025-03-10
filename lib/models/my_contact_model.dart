// To parse this JSON data, do
//
//     final myContact = myContactFromJson(jsonString);

import 'dart:convert';

MyContactDto myContactFromJson(String str) => MyContactDto.fromJson(json.decode(str));

String myContactToJson(MyContactDto data) => json.encode(data.toJson());

class MyContactDto {
  bool? status;
  String? message;
  List<ContactDetailsDatum>? data;

  MyContactDto({
    this.status,
    this.message,
    this.data,
  });

  factory MyContactDto.fromJson(Map<String, dynamic> json) => MyContactDto(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ContactDetailsDatum>.from(json["data"]!.map((x) => ContactDetailsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ContactDetailsDatum {
  int? id;
  int? userId;
  int? cardId;
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
  dynamic qrCode;
  String? backgroungImage;
  String? cardName;
  int? contactTypeId;
  List<Document>? documents;
  List<SocialDto>? socials;

  ContactDetailsDatum({
    this.id,
    this.userId,
    this.cardId,
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
    this.qrCode,
    this.cardName,
    this.contactTypeId,
    this.documents,
    this.socials,
  });

  factory ContactDetailsDatum.fromJson(Map<String, dynamic> json) => ContactDetailsDatum(
    id: json["id"],
    userId: json["user_id"],
    cardId: json["card_id"],
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
    qrCode : json['qr_code'],
    backgroungImage: json["backgroung_image"],
    cardName: json["card_name"],
    contactTypeId: json["contact_type_id"],
    documents: json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x))),
    socials: json["socials"] == null ? [] : List<SocialDto>.from(json["socials"]!.map((x) => SocialDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "card_id": cardId,
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
    'qr_code': qrCode,
  "card_name": cardName,
    "contact_type_id": contactTypeId,
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
    "socials": socials == null ? [] : List<dynamic>.from(socials!.map((x) => x.toJson())),
  };
}

class Document {
  int? id;
  int? contactId;
  String? document;

  Document({
    this.id,
    this.contactId,
    this.document,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    contactId: json["contact_id"],
    document: json["document"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_id": contactId,
    "document": document,
  };
}

class SocialDto {
  int? id;
  int? contactId;
  int? socialId;
  String? socialLink;
  String? socialName;
  String? socialLogo;

  SocialDto({
    this.id,
    this.contactId,
    this.socialId,
    this.socialLink,
    this.socialName,
    this.socialLogo,
  });

  factory SocialDto.fromJson(Map<String, dynamic> json) => SocialDto(
    id: json["id"],
    contactId: json["contact_id"],
    socialId: json["social_id"],
    socialLink: json["social_link"],
    socialName: json["social_name"],
    socialLogo: json["social_logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_id": contactId,
    "social_id": socialId,
    "social_link": socialLink,
    "social_name": socialName,
    "social_logo": socialLogo,
  };
}
