import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class GoogleDriveService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  // Get Google Drive service with authentication
  Future<drive.DriveApi?> getDriveService() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final client = GoogleHttpClient(googleAuth.accessToken!);
      return drive.DriveApi(client);
    } catch (e) {
      print('Error getting Drive service: $e');
      return null;
    }
  }

  // Fetch all photos from Google Drive folder
  Stream<List<Photo>> getPhotosStream({required String googleDriveFolderId}) {
    return firestore
        .collection('photos_cache')
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Photo.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Sync photos from Google Drive folder to Firestore cache
  Future<List<Photo>> syncPhotosFromGoogleDrive({
    required String googleDriveFolderId,
  }) async {
    try {
      final driveApi = await getDriveService();
      if (driveApi == null) {
        print('Could not authenticate with Google Drive');
        return [];
      }

      // Query files in the specific folder
      final fileList = await driveApi.files.list(
        q: "'$googleDriveFolderId' in parents and (mimeType contains 'image/')",
        spaces: 'drive',
        pageSize: 100,
      );

      final photos = <Photo>[];

      if (fileList.files != null) {
        for (final file in fileList.files!) {
          // Get file metadata
          final fileMetadata = await driveApi.files.get(
            file.id!,
            $fields: 'id, name, createdTime, modifiedTime, webContentLink, webViewLink',
          );

          // Create photo object
          final photo = Photo(
            id: file.id ?? '',
            title: file.name ?? 'Photo',
            imageUrl: fileMetadata.webContentLink ?? '',
            uploadDate: file.modifiedTime ?? DateTime.now(),
            uploadedBy: 'Admin (Google Drive)',
          );

          photos.add(photo);

          // Cache in Firestore for real-time updates
          await firestore.collection('photos_cache').doc(file.id).set({
            'id': photo.id,
            'title': photo.title,
            'imageUrl': photo.imageUrl,
            'uploadDate': photo.uploadDate.toIso8601String(),
            'uploadedBy': photo.uploadedBy,
            'driveFileId': file.id,
          });
        }
      }

      return photos;
    } catch (e) {
      print('Error syncing photos from Google Drive: $e');
      return [];
    }
  }

  // Get direct Google Drive file URL (for viewing)
  String getGoogleDriveImageUrl(String fileId) {
    return 'https://drive.google.com/uc?id=$fileId&export=view';
  }

  // Get list of photos with periodic sync
  Future<void> startPeriodicSync({required String googleDriveFolderId}) async {
    // This would sync every 5 minutes in production
    // For now, sync once on app start
    await syncPhotosFromGoogleDrive(googleDriveFolderId: googleDriveFolderId);
  }

  // Delete photo from Firestore cache (doesn't delete from Drive)
  Future<void> deletePhotoCache(String photoId) async {
    try {
      await firestore.collection('photos_cache').doc(photoId).delete();
    } catch (e) {
      print('Error deleting photo cache: $e');
      rethrow;
    }
  }

  // Update photo title in cache
  Future<void> updatePhotoTitle(String photoId, String newTitle) async {
    try {
      await firestore.collection('photos_cache').doc(photoId).update({
        'title': newTitle,
      });
    } catch (e) {
      print('Error updating photo: $e');
      rethrow;
    }
  }
}

// Custom HTTP client for Google Drive API
class GoogleHttpClient extends http.BaseClient {
  final String accessToken;

  GoogleHttpClient(this.accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['authorization'] = 'Bearer $accessToken';
    return super.send(request);
  }
}
