class LanguageModel {
  bool? status;
  List<Data>? data;

  LanguageModel({this.status, this.data});

  LanguageModel.fromJson(Map<String, dynamic> json) {
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
  dynamic languageName;
  dynamic languageCode;

  Data({this.id, this.languageName, this.languageCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
    languageCode = json['language_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_name'] = languageName;
    data['language_code'] = languageCode;
    return data;
  }
}
