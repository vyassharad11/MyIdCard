import 'package:my_di_card/models/my_card_get.dart';

class StoreStepIntialModel {
  bool? status;
  dynamic message;
  Data? data;

  StoreStepIntialModel({this.status, this.message, this.data});

  StoreStepIntialModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic languageId;
  dynamic firstName;
  dynamic lastName;
  int? stepNo;
  int? userId;
  dynamic updatedAt;
  dynamic createdAt;
  int? id;
  dynamic cardImage;

  List<CardDocuments>? cardDocuments;
  List<CardSocials>? cardSocials;

  Data(
      {this.languageId,
      this.firstName,
      this.lastName,
      this.stepNo,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.cardImage,
      this.cardDocuments,
      this.cardSocials});

  Data.fromJson(Map<String, dynamic> json) {
    languageId = json['language_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    stepNo = json['step_no'];
    stepNo = json['step_no'];
    cardImage = json['card_image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
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
    data['language_id'] = languageId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['step_no'] = stepNo;
    data['user_id'] = userId;
    data['card_image'] = cardImage;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (cardDocuments != null) {
      data['cardDocuments'] =
          cardDocuments!.map((v) => v.toJson()).toList();
    }
    if (cardSocials != null) {
      data['cardSocials'] = cardSocials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
