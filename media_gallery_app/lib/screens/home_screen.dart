import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../services/google_drive_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  final String userEmail;

  const HomeScreen({
    Key? key,
    required this.isAdmin,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleDriveService _driveService = GoogleDriveService();
  late String _googleDriveFolderId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoogleDrivePhotos();
  }

  Future<void> _loadGoogleDrivePhotos() async {
    try {
      // Get folder ID from your Google Drive folder
      // Replace with your actual Google Drive folder ID
      _googleDriveFolderId = '1YcDiPwL8wdglpOYOgUwQKRFAP8G1cj_e';

      // Sync photos from Google Drive
      await _driveService.syncPhotosFromGoogleDrive(
        googleDriveFolderId: _googleDriveFolderId,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading photos: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading photos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        elevation: 0,
        actions: [
          // Refresh button to sync from Google Drive
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGoogleDrivePhotos,
            tooltip: 'Sync from Google Drive',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Photo>>(
              stream: _driveService.getPhotosStream(
                googleDriveFolderId: _googleDriveFolderId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final photos = snapshot.data ?? [];

                if (photos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_library,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No photos yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isAdmin
                              ? 'Upload photos to your Google Drive folder'
                              : 'Admin will add photos soon',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (widget.isAdmin)
                          ElevatedButton.icon(
                            onPressed: () {
                              _showGoogleDriveInstructions(context);
                            },
                            icon: const Icon(Icons.help),
                            label: const Text('How to Upload?'),
                          ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return _PhotoTile(
                      photo: photo,
                      driveService: _driveService,
                    );
                  },
                );
              },
            ),
    );
  }

  void _showGoogleDriveInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Photos to Google Drive'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Steps to upload photos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Open your Google Drive folder'),
              Text('2. Click "New" → "File upload"'),
              Text('3. Select photos to upload'),
              Text('4. Wait for upload to complete'),
              Text('5. Tap Refresh button in the app'),
              Text('6. Photos will appear automatically'),
              SizedBox(height: 16),
              Text(
                'Folder Link:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SelectableText(
                'https://drive.google.com/drive/folders/1YcDiPwL8wdglpOYOgUwQKRFAP8G1cj_e',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final Photo photo;
  final GoogleDriveService driveService;

  const _PhotoTile({
    required this.photo,
    required this.driveService,
  });

  @override
  Widget build(BuildContext context) {
    // Convert Google Drive file ID to viewable URL
    final imageUrl = driveService.getGoogleDriveImageUrl(photo.id);

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _PhotoDetailScreen(
                photo: photo,
                imageUrl: imageUrl,
              ),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(photo.uploadDate),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _PhotoDetailScreen extends StatelessWidget {
  final Photo photo;
  final String imageUrl;

  const _PhotoDetailScreen({
    required this.photo,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow('Source:', photo.uploadedBy),
                  _InfoRow('Uploaded:', _formatFullDate(photo.uploadDate)),
                  _InfoRow('File ID:', photo.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
