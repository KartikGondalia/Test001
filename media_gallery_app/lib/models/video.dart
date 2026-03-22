class Video {
  final String id;
  final String title;
  final String youtubeUrl;
  final String year;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.year,
    required this.thumbnailUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      youtubeUrl: json['youtubeUrl'] ?? '',
      year: json['year'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'youtubeUrl': youtubeUrl,
      'year': year,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
