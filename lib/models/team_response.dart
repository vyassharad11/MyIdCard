class TeamResponse {
  final bool status;
  dynamic message;
  final TeamData data;

  TeamResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory constructor for JSON parsing
  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      status: json['status'],
      message: json['message'],
      data: TeamData.fromJson(json['data']),
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TeamData {
  final int id;
  dynamic teamOwnerId;
  dynamic teamName;
  dynamic teamDescription;
  dynamic teamCode;
  dynamic teamLogo;
  dynamic teamPlanId;

  TeamData({
    required this.id,
    required this.teamOwnerId,
    required this.teamName,
    required this.teamDescription,
    required this.teamCode,
    required this.teamLogo,
    required this.teamPlanId,
  });

  // Factory constructor for JSON parsing
  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      id: json['id'],
      teamOwnerId: json['team_owner_id'],
      teamName: json['team_name'],
      teamDescription: json['team_description'],
      teamCode: json['team_code'],
      teamLogo: json['team_logo'],
      teamPlanId: json['team_plan_id'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_owner_id': teamOwnerId,
      'team_name': teamName,
      'team_description': teamDescription,
      'team_code': teamCode,
      'team_logo': teamLogo,
      'team_plan_id': teamPlanId,
    };
  }
}
