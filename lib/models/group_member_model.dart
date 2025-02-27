// To parse this JSON data, do
//
//     final groupMember = groupMemberFromJson(jsonString);

import 'dart:convert';

GroupMember groupMemberFromJson(String str) => GroupMember.fromJson(json.decode(str));

String groupMemberToJson(GroupMember data) => json.encode(data.toJson());

class GroupMember {
  bool? status;
  Data? data;

  GroupMember({
    this.status,
    this.data,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
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
  List<MemberDatum>? data;
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
    data: json["data"] == null ? [] : List<MemberDatum>.from(json["data"]!.map((x) => MemberDatum.fromJson(x))),
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

class MemberDatum {
  int? id;
  dynamic name;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? mode;
  int? userStatusId;
  int? teamId;
  int? groupId;
  int? planId;
  int? profile;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic phonenumber;
  dynamic providerId;
  dynamic avatar;
  String? role;

  MemberDatum({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.mode,
    this.userStatusId,
    this.teamId,
    this.groupId,
    this.planId,
    this.profile,
    this.createdAt,
    this.updatedAt,
    this.phonenumber,
    this.providerId,
    this.avatar,
    this.role,
  });

  factory MemberDatum.fromJson(Map<String, dynamic> json) => MemberDatum(
    id: json["id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    mode: json["mode"],
    userStatusId: json["user_status_id"],
    teamId: json["team_id"],
    groupId: json["group_id"],
    planId: json["plan_id"],
    profile: json["profile"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    phonenumber: json["phonenumber"],
    providerId: json["provider_id"],
    avatar: json["avatar"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "mode": mode,
    "user_status_id": userStatusId,
    "team_id": teamId,
    "group_id": groupId,
    "plan_id": planId,
    "profile": profile,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "phonenumber": phonenumber,
    "provider_id": providerId,
    "avatar": avatar,
    "role": role,
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
