// To parse this JSON data, do
//
//     final meetingDetailsModel = meetingDetailsModelFromJson(jsonString);

import 'dart:convert';

MeetingDetailsModel meetingDetailsModelFromJson(String str) => MeetingDetailsModel.fromJson(json.decode(str));

String meetingDetailsModelToJson(MeetingDetailsModel data) => json.encode(data.toJson());

class MeetingDetailsModel {
  bool? status;
  Data? data;

  MeetingDetailsModel({
    this.status,
    this.data,
  });

  factory MeetingDetailsModel.fromJson(Map<String, dynamic> json) => MeetingDetailsModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
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
  String? backgroungImage;
  String? cardName;
  int? contactStatus;
  int? favorite;
  int? contactId;
  DateTime? dateTime;
  String? address;
  String? link;
  String? notes;
  dynamic title;
  dynamic purpose;

  Data({
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
    this.cardName,
    this.contactStatus,
    this.favorite,
    this.contactId,
    this.dateTime,
    this.address,
    this.link,
    this.notes,
    this.title,
    this.purpose,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    backgroungImage: json["backgroung_image"],
    cardName: json["card_name"],
    contactStatus: json["contact_status"],
    favorite: json["favorite"],
    contactId: json["contact_id"],
    dateTime: json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
    address: json["address"],
    link: json["link"],
    notes: json["notes"],
    title: json["title"],
    purpose: json["purpose"],
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
    "card_name": cardName,
    "contact_status": contactStatus,
    "favorite": favorite,
    "contact_id": contactId,
    "date_time": dateTime?.toIso8601String(),
    "address": address,
    "link": link,
    "notes": notes,
    "title": title,
    "purpose": purpose,
  };
}
