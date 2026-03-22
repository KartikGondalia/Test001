# Media Gallery App - Quick Start Guide

## 🚀 Getting Started

### 1. Clone/Extract Project
```bash
cd c:\Users\karti\OneDrive\Desktop\App\media_gallery_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
1. Go to `lib/firebase_options.dart`
2. Replace placeholders with your Firebase credentials
3. Or use: `flutterfire configure`

### 4. Run the App
```bash
# Android Emulator
flutter run -d android

# iOS Simulator
flutter run -d ios

# Web
flutter run -d chrome
```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Firebase config
├── screens/
│   ├── home_screen.dart      # Photo gallery
│   ├── videos_screen.dart    # YouTube videos
│   └── info_screen.dart      # About page
├── services/
│   ├── auth_service.dart     # Google Sign-In
│   ├── google_drive_service.dart  # Google Drive integration
│   └── youtube_service.dart  # YouTube integration
├── models/
│   ├── photo.dart            # Photo model
│   └── video.dart            # Video model
└── widgets/
    └── common_widgets.dart   # Reusable widgets
```

---

## 🔑 Key Features

### Home Screen (Photos)
- **Admin Upload**: Upload photos with timestamp
- **Real-time Sync**: Firebase Firestore integration
- **Image Viewing**: Tap any photo to view details
- **Metadata**: Shows upload date and uploader info

### Videos Screen (YouTube)
- **Year-wise Filtering**: Browse videos by year
- **YouTube Integration**: Play videos directly
- **Thumbnails**: Auto-generated from YouTube
- **Quick View**: Watch videos without leaving app

### Info Screen
- **About Page**: App information
- **Features List**: Key capabilities
- **Support Info**: Contact information
- **Legal**: Privacy policy & terms

---

## 🔐 Authentication

### Google Sign-In
1. User taps "Sign In" button
2. Google login dialog appears
3. Token sent to Firebase
4. User data stored securely

### Admin Management
- Set users as admins in Firestore `admins` collection
- Only admins can upload photos/videos
- Role-based access control

---

## 📱 Testing on Devices

### Android Testing
```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Generate APK for testing
flutter build apk --debug
```

### iOS Testing
```bash
# Requires macOS + Xcode
flutter run -d ios

# Or open Xcode
open ios/Runner.xcworkspace
```

---

## 🐛 Troubleshooting

### Firebase Connection Issues
```bash
# Verify configuration
flutterfire configure --project=media-gallery-app

# Check internet connectivity
```

### Image Loading Issues
- Ensure image URLs are accessible
- Check Firestore storage permissions
- Verify CORS settings if using external storage

### YouTube Video Issues
- Extract video ID correctly from URL
- Ensure YouTube Data API is enabled
- Check API quota limits

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 📦 Building for Production

### Android
```bash
# Create signed AAB
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
# Create release build
flutter build ios --release

# Open in Xcode for upload
open ios/Runner.xcworkspace
```

---

## 📊 Firebase Firestore Rules

### Development (Test Mode)
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Production (Secure)
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /photos/{doc=**} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    match /videos/{doc=**} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    match /admins/{uid} {
      allow read: if request.auth.uid == uid || isAdmin();
    }
  }
  
  function isAdmin() {
    return request.auth != null && 
      exists(/databases/$(database)/documents/admins/$(request.auth.uid));
  }
}
```

---

## 🎯 Target Audience

- **Max Users**: ~1000
- **Platforms**: Android & iOS
- **Minimum OS**: Android 5.0 (API 21), iOS 12.0
- **Data**: Photos + Year-wise Videos

---

## 📈 Performance Tips

1. **Cache Images**: Use `cached_network_image`
2. **Lazy Load**: Load videos on demand
3. **Pagination**: Load photos in batches
4. **Firestore**: Index frequently queried fields
5. **Firebase**: Set appropriate timeout values

---

## 🔄 Update Process

### Adding New Photos
1. Admin uploads via home screen
2. File saved to Firestore
3. Real-time stream updates all users
4. Timestamp recorded automatically

### Adding New Videos
1. Admin adds YouTube URL
2. Video ID extracted automatically
3. Thumbnail fetched from YouTube
4. Grouped by year automatically

---

## 📞 Support & Help

- **Flutter**: https://flutter.dev
- **Firebase**: https://firebase.google.com
- **YouTube API**: https://developers.google.com/youtube
- **Community**: https://stackoverflow.com/questions/tagged/flutter

---

**Happy developing! Deploy with confidence!** 🎉
