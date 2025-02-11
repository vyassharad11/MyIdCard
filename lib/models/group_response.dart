class GroupDataModel {
  bool? status;
  Data? data;

  GroupDataModel({this.status, this.data});

  GroupDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic teamId;
  dynamic adminId;
  dynamic groupName;
  dynamic groupDescription;
  dynamic groupLogo;

  Data(
      {this.id,
      this.teamId,
      this.adminId,
      this.groupName,
      this.groupDescription,
      this.groupLogo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    adminId = json['admin_id'];
    groupName = json['group_name'];
    groupDescription = json['group_description'];
    groupLogo = json['group_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team_id'] = teamId;
    data['admin_id'] = adminId;
    data['group_name'] = groupName;
    data['group_description'] = groupDescription;
    data['group_logo'] = groupLogo;
    return data;
  }
}
