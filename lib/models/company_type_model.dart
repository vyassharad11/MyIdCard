class CompanyTypeModel {
  bool? status;
  List<DataCompany>? data;

  CompanyTypeModel({this.status, this.data});

  CompanyTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataCompany>[];
      json['data'].forEach((v) {
        data!.add(DataCompany.fromJson(v));
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

class DataCompany {
  int? id;
  dynamic companyType;

  DataCompany({this.id, this.companyType});

  DataCompany.fromJson(Map<String, dynamic> json) {
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
