// To parse this JSON data, do
//
//     final myMeetingModel = myMeetingModelFromJson(jsonString);

import 'dart:convert';

MyMeetingModel myMeetingModelFromJson(String str) => MyMeetingModel.fromJson(json.decode(str));

String myMeetingModelToJson(MyMeetingModel data) => json.encode(data.toJson());

class MyMeetingModel {
  bool? status;
  Data? data;

  MyMeetingModel({
    this.status,
    this.data,
  });

  factory MyMeetingModel.fromJson(Map<String, dynamic> json) => MyMeetingModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  int? currentPage;
  List<MeetingDatum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<MeetingDatum>.from(json["data"]!.map((x) => MeetingDatum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class MeetingDatum {
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
  int? contactTypeId;
  int? contactId;
  DateTime? dateTime;
  String? address;
  String? link;
  String? notes;

  MeetingDatum({
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
    this.contactTypeId,
    this.contactId,
    this.dateTime,
    this.address,
    this.link,
    this.notes,
  });

  factory MeetingDatum.fromJson(Map<String, dynamic> json) => MeetingDatum(
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
    contactTypeId: json["contact_type_id"],
    contactId: json["contact_id"],
    dateTime: json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
    address: json["address"],
    link: json["link"],
    notes: json["notes"],
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
    "contact_type_id": contactTypeId,
    "contact_id": contactId,
    "date_time": dateTime?.toIso8601String(),
    "address": address,
    "link": link,
    "notes": notes,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
