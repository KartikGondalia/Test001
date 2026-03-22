# FLUTTER MEDIA GALLERY APP - COMPLETE SETUP & DEPLOYMENT GUIDE

## 📋 PROJECT OVERVIEW
- **App Name**: Media Gallery
- **Target Users**: ~1000 users
- **Platforms**: iOS & Android (cross-platform Flutter)
- **Features**:
  1. Admin photo upload to Google Drive (real-time sync)
  2. Year-wise YouTube video playlist viewer
  3. App information/about page

---

## ✅ STEP 1: LOCAL DEVELOPMENT SETUP

### 1.1 Prerequisites
- Flutter SDK (latest version)
- Android Studio / Xcode installed
- Firebase CLI
- Google Cloud Project
- YouTube Data API key

### 1.2 Installation Steps

```bash
# 1. Navigate to project
cd c:\Users\karti\OneDrive\Desktop\App\media_gallery_app

# 2. Get Flutter dependencies
flutter pub get

# 3. Build runner (if needed)
flutter pub run build_runner build

# 4. Run the app (choose device)
flutter run -d chrome  # Web
flutter run -d android # Android emulator
flutter run -d ios    # iOS simulator
```

---

## 🔥 STEP 2: FIREBASE SETUP

### 2.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a new project"
3. Name: `media-gallery-app`
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2.2 Register Apps in Firebase

#### Android App:
1. In Firebase Console → Project Settings
2. Click "Add app" → "Android"
3. Package name: `com.example.media_gallery_app`
4. App nickname: `Media Gallery Android`
5. Download `google-services.json`
6. Place it at: `android/app/google-services.json`

#### iOS App:
1. Click "Add app" → "iOS"
2. Bundle ID: `com.example.mediaGalleryApp`
3. App nickname: `Media Gallery iOS`
4. Download `GoogleService-Info.plist`
5. Place it in Xcode: 
   - Open `ios/Runner.xcworkspace`
   - Add file `GoogleService-Info.plist`

### 2.3 Enable Firebase Services

#### Firestore Database:
```
Firebase Console → Firestore Database → Create Database
- Location: us-central1
- Mode: Start in test mode (change to production later)
```

**Create Collections:**

**Collection: `photos`**
```
Document structure:
{
  "id": "doc-id",
  "title": "Photo Title",
  "imageUrl": "https://...",
  "uploadDate": "2026-03-22T10:30:00Z",
  "uploadedBy": "admin@example.com",
  "timestamp": server_timestamp
}
```

**Collection: `videos`**
```
Document structure:
{
  "id": "doc-id",
  "title": "Video Title",
  "youtubeUrl": "https://youtube.com/watch?v=...",
  "year": "2025",
  "thumbnailUrl": "https://img.youtube.com/vi/.../hqdefault.jpg",
  "videoId": "YouTube_Video_ID",
  "addedDate": "2026-03-22T10:30:00Z"
}
```

**Collection: `admins`** (for admin control)
```
Document structure:
{
  "email": "admin@example.com",
  "role": "admin",
  "createdAt": "2026-03-22T10:30:00Z"
}
```

#### Enable Authentication:
1. Firebase → Authentication → Sign-in method
2. Enable: Google Sign-In
3. Set OAuth consent screen in Google Cloud Console
4. Add test users if needed

### 2.4 Firestore Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Photos: Anyone can read, only admins can write
    match /photos/{document=**} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // Videos: Anyone can read, only admins can write
    match /videos/{document=**} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // Admins: Only admins can read and write
    match /admins/{document=**} {
      allow read, write: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
  }
}
```

---

## 🔑 STEP 3: GOOGLE CLOUD SETUP

### 3.1 Enable Required APIs
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Enable these APIs:
   - YouTube Data API v3
   - Google Drive API
   - Cloud Storage

### 3.2 Create API Keys
1. **YouTube API Key**:
   - APIs & Services → Credentials
   - Create API Key (restrict to Android/iOS)
   - Note this key for later

2. **OAuth 2.0 Client IDs**:
   - Android: Add SHA-1 fingerprint
   - iOS: Create iOS OAuth client ID

### 3.3 Get Android SHA-1 Fingerprint
```bash
# Generate debug key
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

---

## 🎨 STEP 4: UPDATE APP CONFIGURATION

### 4.1 Update firebase_options.dart
```bash
# Use FlutterFire CLI
flutterfire configure
```

Or manually update `lib/firebase_options.dart` with your credentials.

### 4.2 Update Android Configuration
**android/app/build.gradle**:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.media_gallery_app"
        minSdkVersion 21
        targetSdkVersion 34
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
}
```

### 4.3 Update iOS Configuration
**ios/Podfile**:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

---

## 📱 STEP 5: ANDROID DEPLOYMENT

### 5.1 Build Production APK/AAB

```bash
# Create signed AAB (recommended for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 5.2 Create Google Play Store Account
1. Go to [Google Play Console](https://play.google.com/console)
2. Create developer account ($25 one-time fee)
3. Fill in merchant account details
4. Verify email

### 5.3 Create App in Play Console
1. **Create app**:
   - App name: "Media Gallery"
   - Default language: English
   - App or game: App
   - Category: Photography
   - Type: Free

2. **Fill in store listing**:
   - Short description
   - Full description
   - Screenshots (at least 2)
   - Feature graphic (1024x500 px)
   - Icon (512x512 px)
   - Video URL (optional)

### 5.4 Upload and Release

```bash
# Using bundletool
bundletool build-apks \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=app.apks \
  --ks=upload.keystore \
  --ks-pass=pass:password \
  --ks-key-alias=upload \
  --key-pass=pass:password
```

**In Play Console:**
1. Release → Production
2. Create new release
3. Upload AAB file
4. Fill in release notes
5. Review privacy policy
6. Submit for review (24-48 hours)

---

## 🍎 STEP 6: iOS DEPLOYMENT

### 6.1 Prepare iOS Build

```bash
# Update iOS deployment target
flutter build ios --release
```

**Update Info.plist** (`ios/Runner/Info.plist`):
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos for uploading</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access for taking photos</string>
```

### 6.2 Create Apple Developer Account
1. Go to [Apple Developer](https://developer.apple.com)
2. Enroll as individual ($99/year)
3. Agree to agreements
4. Set up payment

### 6.3 Create App ID & Certificates

**In Apple Developer:**
1. Certificates → Create new certificate (iOS Distribution)
2. App IDs → Create identifier `com.example.mediaGalleryApp`
3. Provisioning Profiles → Create distribution profile

### 6.4 Build and Upload to App Store

```bash
# Build for App Store
flutter build ios --release

# Open Xcode
open ios/Runner.xcworkspace
```

**In Xcode:**
1. Select "Runner" project
2. Build Settings → Team (select your team)
3. Version & Build number
4. Product → Archive
5. Window → Organizer
6. Distribute App

**In App Store Connect:**
1. Create new app
2. Bundle ID: `com.example.mediaGalleryApp`
3. SKU: `MediaGallery2026`
4. Fill app information
5. Upload with Xcode (automatic or via Transporter)

---

## 📊 STEP 7: APP STORE LISTING

### Content Rating
- Go to App Store Connect → App Information
- Answer content rating questionnaire
- Ratings will be generated

### Privacy
- Add privacy policy URL
- Declare data practices
- (Recommended: Create on privacypolicygenerator.info)

### Pricing & Availability
- Set as Free
- Select regions
- Set release date

### Review Guidelines
- Ensure app follows Apple/Google policies
- Test on real devices
- Include instructions for reviewers

---

## 🔐 STEP 8: POST-LAUNCH

### 8.1 Monitoring
```bash
# Firebase Console:
- Analytics
- Crashlytics
- Performance Monitoring
- Remote Config
```

### 8.2 Update Firestore Rules to Production

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /photos/{document=**} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.role == 'admin';
    }
    
    match /videos/{document=**} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.role == 'admin';
    }
    
    match /admins/{uid} {
      allow read, write: if request.auth.uid == uid || 
        (request.auth != null && get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.role == 'admin');
    }
  }
}
```

### 8.3 Set Up Admin Users
1. In Firestore Console → Add admin documents
2. Add your email as admin

---

## 🚀 QUICK DEPLOYMENT CHECKLIST

- [ ] Firebase project created
- [ ] Firestore collections set up
- [ ] Google authentication enabled
- [ ] Android package name: `com.example.media_gallery_app`
- [ ] iOS bundle ID: `com.example.mediaGalleryApp`
- [ ] google-services.json placed (Android)
- [ ] GoogleService-Info.plist placed (iOS)
- [ ] firebase_options.dart configured
- [ ] Play Store account created
- [ ] App Store account created
- [ ] App icons created (1024x1024)
- [ ] Screenshots captured
- [ ] Privacy policy URL created
- [ ] Build tested on real devices
- [ ] AAB/IPA files generated and signed
- [ ] Submitted to Play Store & App Store
- [ ] Confirmed approval emails received

---

## 📚 USEFUL RESOURCES

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Play Store Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [YouTube Data API](https://developers.google.com/youtube/v3)

---

**Ready to deploy today! Follow all steps carefully.** 🎉
