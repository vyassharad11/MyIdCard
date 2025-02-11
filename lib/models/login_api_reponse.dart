import 'user_data_model.dart';

class LoginApiResponse {
  dynamic status;
  dynamic message;
  dynamic token;
  User? user;

  LoginApiResponse({this.status, this.message, this.token, this.user});

  LoginApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}


