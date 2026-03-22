import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video.dart';

class YouTubeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Extract YouTube video ID from various URL formats
  String? extractYoutubeId(String url) {
    final regex = RegExp(
      r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([^\&\?\/\r\n\t]+)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  // Fetch videos by year
  Stream<List<Video>> getVideosByYearStream(String year) {
    return firestore
        .collection('videos')
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Video.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Fetch all years
  Future<List<String>> getAvailableYears() async {
    try {
      final snapshot = await firestore.collection('videos').get();
      final years = <String>{};
      
      for (var doc in snapshot.docs) {
        final year = doc['year'] as String?;
        if (year != null && year.isNotEmpty) {
          years.add(year);
        }
      }
      
      return years.toList()..sort((a, b) => b.compareTo(a));
    } catch (e) {
      print('Error fetching years: $e');
      return [];
    }
  }

  // Add video metadata
  Future<void> addVideo(String title, String youtubeUrl, String year) async {
    try {
      final videoId = extractYoutubeId(youtubeUrl);
      if (videoId == null) {
        throw Exception('Invalid YouTube URL');
      }

      final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

      await firestore.collection('videos').add({
        'title': title,
        'youtubeUrl': youtubeUrl,
        'year': year,
        'thumbnailUrl': thumbnailUrl,
        'videoId': videoId,
        'addedDate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding video: $e');
      rethrow;
    }
  }

  // Delete video
  Future<void> deleteVideo(String videoId) async {
    try {
      await firestore.collection('videos').doc(videoId).delete();
    } catch (e) {
      print('Error deleting video: $e');
      rethrow;
    }
  }
}
