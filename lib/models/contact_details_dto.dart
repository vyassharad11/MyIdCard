// To parse this JSON data, do
//
//     final contactDetailsDto = contactDetailsDtoFromJson(jsonString);

import 'dart:convert';

import 'my_contact_model.dart';

ContactDetailsDto contactDetailsDtoFromJson(String str) => ContactDetailsDto.fromJson(json.decode(str));

String contactDetailsDtoToJson(ContactDetailsDto data) => json.encode(data.toJson());

class ContactDetailsDto {
  bool? status;
  String? message;
  DataContact? data;

  ContactDetailsDto({
    this.status,
    this.message,
    this.data,
  });

  factory ContactDetailsDto.fromJson(Map<String, dynamic> json) => ContactDetailsDto(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DataContact.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataContact {
  int? id;
  int? userId;
  int? cardId;
  int? languageId;
  int? contactTypeId;
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
  String? email;
  String? phone;
  String? cardStyle;
  String? backgroungImage;
  String? cardName;
  int? contactStatus;
  int? favorite;
  int? cardTypeId;
  String? notes;
  String? qrCode;
  List<CardDocument>? cardDocuments;
  List<CardSocial>? cardSocials;
  List<ContactTag>? contactTags;

  DataContact({
    this.id,
    this.userId,
    this.cardId,
    this.languageId,
    this.contactTypeId,
    this.cardImage,
    this.firstName,
    this.lastName,
    this.companyName,
    this.companyLogo,
    this.companyTypeId,
    this.jobTitle,
    this.qrCode,
    this.companyAddress,
    this.companyWebsite,
    this.workEmail,
    this.phoneNo,
    this.email,
    this.phone,
    this.cardStyle,
    this.backgroungImage,
    this.cardName,
    this.contactStatus,
    this.favorite,
    this.cardTypeId,
    this.notes,
    this.cardDocuments,
    this.cardSocials,
    this.contactTags,
  });

  factory DataContact.fromJson(Map<String, dynamic> json) => DataContact(
    id: json["id"],
    userId: json["user_id"],
    cardId: json["card_id"],
    languageId: json["language_id"],
    contactTypeId: json["contact_type_id"],
    cardImage: json["card_image"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    qrCode: json["qr_code"],
    companyName: json["company_name"],
    companyLogo: json["company_logo"],
    companyTypeId: json["company_type_id"],
    jobTitle: json["job_title"],
    companyAddress: json["company_address"],
    companyWebsite: json["company_website"],
    workEmail: json["work_email"],
    phoneNo: json["phone_no"],
    email: json["email"],
    phone: json["phone"],
    cardStyle: json["card_style"],
    backgroungImage: json["backgroung_image"],
    cardName: json["card_name"],
    contactStatus: json["contact_status"],
    favorite: json["favorite"],
    cardTypeId: json["card_type_id"],
    notes: json["notes"],
    cardDocuments: json["cardDocuments"] == null ? [] : List<CardDocument>.from(json["cardDocuments"]!.map((x) => CardDocument.fromJson(x))),
    cardSocials: json["cardSocials"] == null ? [] : List<CardSocial>.from(json["cardSocials"]!.map((x) => CardSocial.fromJson(x))),
    contactTags: json["contactTags"] == null ? [] : List<ContactTag>.from(json["contactTags"]!.map((x) => ContactTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "card_id": cardId,
    "language_id": languageId,
    "contact_type_id": contactTypeId,
    "card_image": cardImage,
    "first_name": firstName,
    "qr_code": qrCode,
    "last_name": lastName,
    "company_name": companyName,
    "company_logo": companyLogo,
    "company_type_id": companyTypeId,
    "job_title": jobTitle,
    "company_address": companyAddress,
    "company_website": companyWebsite,
    "work_email": workEmail,
    "email": email,
    "phone_no": phoneNo,
    "card_style": cardStyle,
    "backgroung_image": backgroungImage,
    "card_name": cardName,
    "contact_status": contactStatus,
    "favorite": favorite,
    "card_type_id": cardTypeId,
    "notes": notes,
    "cardDocuments": cardDocuments == null ? [] : List<dynamic>.from(cardDocuments!.map((x) => x.toJson())),
    "cardSocials": cardSocials == null ? [] : List<dynamic>.from(cardSocials!.map((x) => x.toJson())),
    "contactTags": contactTags == null ? [] : List<dynamic>.from(contactTags!.map((x) => x.toJson())),
  };
}

class CardDocument {
  int? id;
  int? contactId;
  String? document;
  String? documentsName;

  CardDocument({
    this.id,
    this.contactId,
    this.document,
    this.documentsName,
  });

  factory CardDocument.fromJson(Map<String, dynamic> json) => CardDocument(
    id: json["id"],
    contactId: json["contact_id"],
    document: json["document"],
    documentsName: json["documentsName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_id": contactId,
    "document": document,
    "documentsName": documentsName,
  };
}

class CardSocial {
  int? id;
  int? contactId;
  int? socialId;
  String? socialLink;
  String? socialUrl;

  String? socialName;
  String? socialLogo;

  CardSocial({
    this.id,
    this.contactId,
    this.socialId,
    this.socialLink,
    this.socialUrl,
    this.socialName,
    this.socialLogo,
  });

  factory CardSocial.fromJson(Map<String, dynamic> json) => CardSocial(
    id: json["id"],
    contactId: json["contact_id"],
    socialId: json["social_id"],
    socialLink: json["social_link"],
    socialUrl: json["social_url"],
    socialName: json["social_name"],
    socialLogo: json["social_logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_id": contactId,
    "social_id": socialId,
    "social_link": socialLink,
    "social_url": socialUrl,
    "social_name": socialName,
    "social_logo": socialLogo,
  };
}
