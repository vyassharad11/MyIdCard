// To parse this JSON data, do
//
//     final myContactDto = myContactDtoFromJson(jsonString);

import 'dart:convert';

MyContactDto myContactDtoFromJson(String str) => MyContactDto.fromJson(json.decode(str));

String myContactDtoToJson(MyContactDto data) => json.encode(data.toJson());

class MyContactDto {
  bool? status;
  String? message;
  Data? data;

  MyContactDto({
    this.status,
    this.message,
    this.data,
  });

  factory MyContactDto.fromJson(Map<String, dynamic> json) => MyContactDto(
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
  int? currentPage;
  List<ContactDatum>? data;
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
    data: json["data"] == null ? [] : List<ContactDatum>.from(json["data"]!.map((x) => ContactDatum.fromJson(x))),
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

class ContactDatum {
  int? id;
  int? userId;
  int? cardId;
  int? cardTypeId;
  int? languageId;
  String? cardImage;
  String? firstName;
  String? lastName;
  String? notes;
  String? companyName;
  String? qrCode;
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
  List<dynamic>? documents;
  List<Social>? socials;
  List<ContactTag>? contactTags;

  ContactDatum({
    this.id,
    this.userId,
    this.cardId,
    this.qrCode,
    this.cardTypeId,
    this.languageId,
    this.cardImage,
    this.firstName,
    this.lastName,
    this.notes,
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
    this.documents,
    this.socials,
    this.contactTags,
  });

  factory ContactDatum.fromJson(Map<String, dynamic> json) => ContactDatum(
    id: json["id"],
    userId: json["user_id"],
    cardId: json["card_id"],
    cardTypeId: json["card_type_id"],
    languageId: json["language_id"],
    cardImage: json["card_image"],
    firstName: json["first_name"],
    qrCode: json["qr_code"],
    lastName: json["last_name"],
    notes: json["notes"],
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
    documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
    socials: json["socials"] == null ? [] : List<Social>.from(json["socials"]!.map((x) => Social.fromJson(x))),
    contactTags: json["contactTags"] == null ? [] : List<ContactTag>.from(json["contactTags"]!.map((x) => ContactTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "card_id": cardId,
    "card_type_id": cardTypeId,
    "language_id": languageId,
    "qr_code": qrCode,
    "card_image": cardImage,
    "first_name": firstName,
    "last_name": lastName,
    "notes": notes,
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
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
    "socials": socials == null ? [] : List<dynamic>.from(socials!.map((x) => x.toJson())),
    "contactTags": contactTags == null ? [] : List<dynamic>.from(contactTags!.map((x) => x.toJson())),
  };
}


class ContactTag {
  int? id;
  int? contactId;
  int? contactTagId;

  ContactTag({
    this.id,
    this.contactId,
    this.contactTagId,
  });

  factory ContactTag.fromJson(Map<String, dynamic> json) => ContactTag(
    id: json["id"],
    contactId: json["contact_id"],
    contactTagId: json["contact_tag_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_id": contactId,
    "contact_tag_id": contactTagId,
  };
}

class Social {
  int? id;
  int? contactId;
  int? socialId;
  String? socialLink;
  String? socialName;
  String? socialLogo;

  Social({
    this.id,
    this.contactId,
    this.socialId,
    this.socialLink,
    this.socialName,
    this.socialLogo,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
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
