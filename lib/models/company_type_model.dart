class CompanyTypeModel {
  bool? status;
  List<Data>? data;

  CompanyTypeModel({this.status, this.data});

  CompanyTypeModel.fromJson(Map<String, dynamic> json) {
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
  dynamic companyType;

  Data({this.id, this.companyType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyType = json['company_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_type'] = companyType;
    return data;
  }
}
