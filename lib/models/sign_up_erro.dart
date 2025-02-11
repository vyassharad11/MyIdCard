
class ApiErrorResponse {
  final String message;
  final Map<String, List<String>> errors;

  ApiErrorResponse({
    required this.message,
    required this.errors,
  });

  // Factory method to create an instance from JSON
  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      message: json['message'] as String,
      errors: (json['errors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          List<String>.from(value as List),
        ),
      ),
    );
  }

  // Convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors.map(
        (key, value) => MapEntry(key, value),
      ),
    };
  }
}
