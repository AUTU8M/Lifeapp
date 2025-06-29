class Campaign {
  final int id;
  final String title;
  final String description;
  final int gameType;       // int from 'game_type'
  final int referenceId;    // int from 'reference_id'
  final String scheduledFor;
  final String referenceTitle;
  final String buttonName;  // <-- matches "button_name"
  final String imageUrl;
  final String subjectId;     // mapped from 'la_subject_id'
  final String levelId;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.gameType,
    required this.referenceId,
    required this.scheduledFor,
    required this.buttonName,
    required this.referenceTitle,
    required this.imageUrl,
    required this.subjectId,
    required this.levelId,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      gameType: json['game_type'] ?? 0,        // Match API key
      referenceId: json['reference_id'] ?? 0,
      buttonName: json['button_name'] ?? 'Start',  // fallback// Match API key
      scheduledFor: json['scheduled_for'] ?? '',
      referenceTitle: json['reference_title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      subjectId: json['la_subject_id']?.toString() ?? '',
      levelId: json['la_level_id']?.toString() ?? '',
    );
  }
}
