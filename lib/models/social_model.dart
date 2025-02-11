class SocialModel {
  bool? status;
  List<Data>? data;

  SocialModel({this.status, this.data});

  SocialModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  dynamic socialName;
  dynamic socialLogo;

  Data({this.id, this.socialName, this.socialLogo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    socialName = json['social_name'];
    socialLogo = json['social_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['social_name'] = socialName;
    data['social_logo'] = socialLogo;
    return data;
  }
}
