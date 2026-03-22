# Media Gallery App - README

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A cross-platform Flutter application for managing and sharing photos and videos.

## Features

✨ **Photo Gallery**
- Admin photo upload directly to Google Drive
- Real-time sync with Firestore
- Photo details with upload timestamp
- Grid view gallery display

🎥 **Video Library**
- Year-wise YouTube video organization
- Direct YouTube video playback
- Automatic thumbnail generation
- Smooth video streaming

ℹ️ **Information Page**
- App features overview
- Support information
- Privacy policy & terms
- Legal information

🔐 **Security**
- Google Sign-In authentication
- Firebase Firestore integration
- Role-based access control
- Secure data storage

## Tech Stack

- **Framework**: Flutter 3.0+
- **Backend**: Firebase (Firestore, Authentication)
- **APIs**: YouTube Data API, Google Drive API
- **State Management**: Provider (optional)
- **Video Player**: youtube_player_flutter
- **Image Handling**: cached_network_image

## Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- Firebase Account
- Google Cloud Project
- YouTube API Key
- Android Studio / Xcode

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/media_gallery_app.git
cd media_gallery_app
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure for your Firebase project
flutterfire configure
```

### 4. Update Configuration
- Edit `lib/firebase_options.dart` with your credentials
- Add YouTube API key
- Update package names (Android/iOS)

### 5. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                  # Application entry point
├── firebase_options.dart      # Firebase configuration
├── screens/                   # UI screens
│   ├── home_screen.dart
│   ├── videos_screen.dart
│   └── info_screen.dart
├── services/                  # Backend services
│   ├── auth_service.dart
│   ├── google_drive_service.dart
│   └── youtube_service.dart
├── models/                    # Data models
│   ├── photo.dart
│   └── video.dart
└── widgets/                   # Reusable widgets
    └── common_widgets.dart
```

## Usage

### For Users
1. Launch the app
2. Sign in with Google account
3. Browse photos and videos
4. Save favorite videos (if admin)

### For Admins
1. Sign in as admin
2. Tap the "+" button on home screen
3. Upload photos from gallery
4. Photos automatically sync to all users
5. Add videos by YouTube URL

## Deployment

### Android
```bash
flutter build appbundle --release
```
Upload to Google Play Console

### iOS
```bash
flutter build ios --release
```
Upload to App Store Connect

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed steps.

## Configuration

### Firestore Collections

**photos**
```json
{
  "id": "unique_id",
  "title": "Photo Title",
  "imageUrl": "https://...",
  "uploadDate": "2026-03-22T10:30:00Z",
  "uploadedBy": "admin@example.com"
}
```

**videos**
```json
{
  "id": "unique_id",
  "title": "Video Title",
  "youtubeUrl": "https://youtube.com/watch?v=...",
  "year": "2025",
  "thumbnailUrl": "https://img.youtube.com/vi/.../hqdefault.jpg"
}
```

**admins**
```json
{
  "email": "admin@example.com",
  "role": "admin"
}
```

## Firebase Rules

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md#firestore-security-rules) for security rules.

## API Keys Required

1. **YouTube Data API**
   - Enable in Google Cloud Console
   - Create API key

2. **Google Sign-In**
   - Configure OAuth consent screen
   - Add Android/iOS credentials

3. **Firebase**
   - Create project
   - Enable Firestore & Authentication
   - Download configuration files

## Performance Optimization

- Lazy loading of images
- Firestore query indexing
- YouTube thumbnail caching
- Pagination for photo gallery
- Efficient state management

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Manual Testing
- Test on Android device
- Test on iOS device
- Test on different network speeds
- Test offline functionality

## Troubleshooting

### Firebase Connection Issues
- Verify firebase_options.dart configuration
- Check Firebase project settings
- Ensure internet connectivity

### Image Loading
- Verify image URLs are accessible
- Check Firestore storage permissions
- Test with different image formats

### YouTube Video Issues
- Validate YouTube URL format
- Ensure API quota not exceeded
- Check API key permissions

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@mediagallery.com
- 🌐 Website: www.mediagallery.com
- 📱 Issues: [GitHub Issues](https://github.com/yourusername/media_gallery_app/issues)

## Changelog

### Version 1.0.0 (March 22, 2026)
- Initial release
- Photo gallery feature
- YouTube video integration
- Google Sign-In authentication
- Firestore real-time sync

## Roadmap

- [ ] Offline mode support
- [ ] Video download capability
- [ ] Photo filters and editing
- [ ] User comments on photos
- [ ] Dark theme support
- [ ] Multi-language support
- [ ] Push notifications

## Authors

- **Your Name** - Initial work

## Acknowledgments

- Flutter community
- Firebase team
- YouTube API documentation
- All contributors

---

**Made with ❤️ by Media Gallery Team**
