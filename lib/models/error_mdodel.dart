class ErrorModel {
  final bool status;
  final String error;
  final String message;

  ErrorModel({
    required this.status,
    required this.error,
    required this.message,
  });

  // Factory method to parse JSON into the ApiResponse object
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] as bool,
      error: json['error'] as String,
      message: json['message'] as String,
    );
  }
}
