import 'my_card_get.dart';

class User {
  int? id;
  dynamic name;
  dynamic firstName;
  dynamic lastName;
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
  dynamic phonenumber;
  dynamic providerId;
  dynamic avatar;
  dynamic role;
  List<Cards>? cards;

  User(
      {this.id,
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
      this.cards});

  // Factory method to create a User instance from JSON
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    mode = json['mode'];
    userStatusId = json['user_status_id'];
    teamId = json['team_id'];
    groupId = json['group_id'];
    planId = json['plan_id'];
    profile = json['profile'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phonenumber = json['phonenumber'];
    providerId = json['provider_id'];
    avatar = json['avatar'];
    role = json['role'];
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards!.add(Cards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['mode'] = mode;
    data['user_status_id'] = userStatusId;
    data['team_id'] = teamId;
    data['group_id'] = groupId;
    data['plan_id'] = planId;
    data['profile'] = profile;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['phonenumber'] = phonenumber;
    data['provider_id'] = providerId;
    data['avatar'] = avatar;
    data['role'] = role;
    if (cards != null) {
      data['cards'] = cards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
