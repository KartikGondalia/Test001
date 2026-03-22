class Photo {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime uploadDate;
  final String uploadedBy;

  Photo({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.uploadDate,
    required this.uploadedBy,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      uploadDate: DateTime.parse(json['uploadDate'] ?? DateTime.now().toString()),
      uploadedBy: json['uploadedBy'] ?? 'Admin',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'uploadDate': uploadDate.toIso8601String(),
      'uploadedBy': uploadedBy,
    };
  }
}
