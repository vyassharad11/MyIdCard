class Company {
  final int id;
  final String? companyType;

  Company({required this.id, required this.companyType});

  // Factory method to create a Company object from JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyType: json['company_type'],
    );
  }
}
