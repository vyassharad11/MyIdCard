

// Data Model Class
class Social {
  final int id;
  final String socialName;
  final String socialLogo;

  Social({
    required this.id,
    required this.socialName,
    required this.socialLogo,
  });

  // Factory constructor to create a Social object from JSON
  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      id: json['id'],
      socialName: json['social_name'],
      socialLogo: json['social_logo'],
    );
  }
}