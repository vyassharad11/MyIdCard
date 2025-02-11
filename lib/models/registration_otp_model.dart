import 'user_data_model.dart';

class RegistrationApiResponse {
  final bool status;
  final String message;
  final User user;

  RegistrationApiResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  // Factory method to create an ApiResponse instance from JSON
  factory RegistrationApiResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationApiResponse(
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }

  // Method to convert ApiResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
    };
  }
}
