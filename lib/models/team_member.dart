class TeamMembersResponse {
  final bool status;
  final TeamMembersData data;

  TeamMembersResponse({
    required this.status,
    required this.data,
  });

  factory TeamMembersResponse.fromJson(Map<String, dynamic> json) {
    return TeamMembersResponse(
      status: json['status'],
      data: TeamMembersData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class TeamMembersData {
  dynamic currentPage;
  final List<Member> members;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  final List<PageLink> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  TeamMembersData({
    required this.currentPage,
    required this.members,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory TeamMembersData.fromJson(Map<String, dynamic> json) {
    return TeamMembersData(
      currentPage: json['current_page'],
      members: (json['data'] as List).map((e) => Member.fromJson(e)).toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List).map((e) => PageLink.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': members.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class Member {
  dynamic id;
  dynamic name;
  dynamic firstName;
  dynamic lastName;
  dynamic role;
  dynamic email;
  dynamic emailVerifiedAt;
  dynamic mode;
  dynamic userStatusId;
  dynamic teamId;
  dynamic groupId;
  dynamic planId;
  dynamic profile;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic phoneNumber;
  dynamic providerId;
  dynamic avatar;

  Member({
    required this.id,
    this.name,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    this.emailVerifiedAt,
    required this.mode,
    required this.userStatusId,
    required this.teamId,
    this.groupId,
    required this.planId,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.providerId,
    this.avatar,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      firstName: json['first_name'],
      role: json['role'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      mode: json['mode'],
      userStatusId: json['user_status_id'],
      teamId: json['team_id'],
      groupId: json['group_id'],
      planId: json['plan_id'],
      profile: json['profile'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      phoneNumber: json['phonenumber'],
      providerId: json['provider_id'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'role': role,
      'last_name': lastName,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'mode': mode,
      'user_status_id': userStatusId,
      'team_id': teamId,
      'group_id': groupId,
      'plan_id': planId,
      'profile': profile,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'phonenumber': phoneNumber,
      'provider_id': providerId,
      'avatar': avatar,
    };
  }
}

class PageLink {
  dynamic url;
  dynamic label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
