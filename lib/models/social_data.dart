// To parse this JSON data, do
//
//     final social = socialFromJson(jsonString);

import 'dart:convert';

Social socialFromJson(String str) => Social.fromJson(json.decode(str));

String socialToJson(Social data) => json.encode(data.toJson());

class Social {
  bool? status;
  List<SocialDatum>? data;

  Social({
    this.status,
    this.data,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    status: json["status"],
    data: json["data"] == null ? [] : List<SocialDatum>.from(json["data"]!.map((x) => SocialDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SocialDatum {
  int? id;
  SocialName? socialName;
  SocialLogo? socialLogo;

  SocialDatum({
    this.id,
    this.socialName,
    this.socialLogo,
  });

  factory SocialDatum.fromJson(Map<String, dynamic> json) => SocialDatum(
    id: json["id"],
    socialName: socialNameValues.map[json["social_name"]]!,
    socialLogo: socialLogoValues.map[json["social_logo"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "social_name": socialNameValues.reverse[socialName],
    "social_logo": socialLogoValues.reverse[socialLogo],
  };
}

enum SocialLogo {
  SOCIALS_FACEBOOK_PNG,
  SOCIALS_INSTAGRAM_PNG,
  SOCIALS_LINKEDIN_PNG,
  SOCIALS_OTHER_PNG,
  SOCIALS_TWITTER_PNG
}

final socialLogoValues = EnumValues({
  "socials/facebook.png": SocialLogo.SOCIALS_FACEBOOK_PNG,
  "socials/instagram.png": SocialLogo.SOCIALS_INSTAGRAM_PNG,
  "socials/linkedin.png": SocialLogo.SOCIALS_LINKEDIN_PNG,
  "socials/other.png": SocialLogo.SOCIALS_OTHER_PNG,
  "socials/twitter.png": SocialLogo.SOCIALS_TWITTER_PNG
});

enum SocialName {
  FACEBOOK,
  INSTAGRAM,
  LINKED_IN,
  OTHER,
  TWITTER
}

final socialNameValues = EnumValues({
  "Facebook": SocialName.FACEBOOK,
  "Instagram": SocialName.INSTAGRAM,
  "LinkedIn": SocialName.LINKED_IN,
  "Other": SocialName.OTHER,
  "Twitter": SocialName.TWITTER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
