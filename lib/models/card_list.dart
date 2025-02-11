import 'card_get_model.dart';

class CardListModel {
  bool? status;
  dynamic message;
  List<Data>? data;

  CardListModel({this.status, this.message, this.data});

  CardListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  dynamic userId;
  dynamic languageId;
  dynamic cardImage;
  dynamic firstName;
  dynamic lastName;
  dynamic companyName;
  dynamic companyLogo;
  dynamic companyTypeId;
  dynamic jobTitle;
  dynamic companyAddress;
  dynamic companyWebsite;
  dynamic workEmail;
  dynamic phoneNo;
  dynamic cardStyle;
  dynamic backgroungImage;
  dynamic cardName;
  dynamic stepNo;
  dynamic createdAt;
  dynamic updatedAt;
  List<CardDocuments>? cardDocuments;
  List<CardSocials>? cardSocials;

  Data(
      {this.id,
      this.userId,
      this.languageId,
      this.cardImage,
      this.firstName,
      this.lastName,
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
      this.stepNo,
      this.createdAt,
      this.updatedAt,
      this.cardDocuments,
      this.cardSocials});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    languageId = json['language_id'];
    cardImage = json['card_image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    companyName = json['company_name'];
    companyLogo = json['company_logo'];
    companyTypeId = json['company_type_id'];
    jobTitle = json['job_title'];
    companyAddress = json['company_address'];
    companyWebsite = json['company_website'];
    workEmail = json['work_email'];
    phoneNo = json['phone_no'];
    cardStyle = json['card_style'];
    backgroungImage = json['backgroung_image'];
    cardName = json['card_name'];
    stepNo = json['step_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['cardDocuments'] != null) {
      cardDocuments = <CardDocuments>[];
      json['cardDocuments'].forEach((v) {
        cardDocuments!.add(CardDocuments.fromJson(v));
      });
    }
    if (json['cardSocials'] != null) {
      cardSocials = <CardSocials>[];
      json['cardSocials'].forEach((v) {
        cardSocials!.add(CardSocials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['language_id'] = languageId;
    data['card_image'] = cardImage;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company_name'] = companyName;
    data['company_logo'] = companyLogo;
    data['company_type_id'] = companyTypeId;
    data['job_title'] = jobTitle;
    data['company_address'] = companyAddress;
    data['company_website'] = companyWebsite;
    data['work_email'] = workEmail;
    data['phone_no'] = phoneNo;
    data['card_style'] = cardStyle;
    data['backgroung_image'] = backgroungImage;
    data['card_name'] = cardName;
    data['step_no'] = stepNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (cardDocuments != null) {
            data['cardDocuments'] = cardDocuments!.map((v) => v.toJson()).toList();
    }
    if (cardSocials != null) {
      data['cardSocials'] = cardSocials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

