# EXACT SETUP INSTRUCTIONS - FOLLOW THESE STEP BY STEP

## 🔥 STEP 1: CREATE FIREBASE PROJECT (10 minutes)

### 1.1 Go to Firebase Console
```
https://console.firebase.google.com
```

### 1.2 Create Project
1. Click "Add project"
2. Project name: `media-gallery-app`
3. Click "Continue"
4. Google Analytics: Disable (optional)
5. Click "Create project"
6. Wait for creation (2-3 minutes)

### 1.3 Register Android App
1. From console, click Android icon (or add app)
2. Package name: `com.example.media_gallery_app`
3. App nickname: `Media Gallery Android`
4. App store ID: Leave empty for now
5. Register app
6. Download `google-services.json`
7. Place at: `android/app/google-services.json`

### 1.4 Register iOS App
1. Click Apple icon (or add app)
2. Bundle ID: `com.example.mediaGalleryApp`
3. App nickname: `Media Gallery iOS`
4. App Store ID: Leave empty
5. Register app
6. Download `GoogleService-Info.plist`
7. In Xcode: Add file to Runner project

---

## 🗄️ STEP 2: SETUP FIRESTORE DATABASE (5 minutes)

### 2.1 Create Firestore Database
1. Firebase Console → Firestore Database
2. Click "Create Database"
3. Location: `us-central1` (or nearest)
4. Mode: **Start in test mode** (we'll secure it later)
5. Click "Create"
6. Wait for initialization

### 2.2 Create Collections and Sample Data

**Collection 1: `photos`**
```
1. Click "Create collection"
2. Collection ID: photos
3. Add first document:
   - Document ID: auto (click auto-id)
   - Fields:
     * title: (string) "Sample Photo"
     * imageUrl: (string) "https://via.placeholder.com/400x300"
     * uploadDate: (timestamp) today's date
     * uploadedBy: (string) "admin@example.com"
4. Save
```

**Collection 2: `videos`**
```
1. Click "Create collection"
2. Collection ID: videos
3. Add first document:
   - Document ID: auto
   - Fields:
     * title: (string) "Sample Video"
     * youtubeUrl: (string) "https://youtube.com/watch?v=dQw4w9WgXcQ"
     * year: (string) "2025"
     * thumbnailUrl: (string) "https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg"
     * videoId: (string) "dQw4w9WgXcQ"
4. Save
```

**Collection 3: `admins`**
```
1. Click "Create collection"
2. Collection ID: admins
3. Add first document:
   - Document ID: <your-uid> (use your email for now)
   - Fields:
     * email: (string) "your-email@gmail.com"
     * role: (string) "admin"
4. Save
```

---

## 🔐 STEP 3: ENABLE AUTHENTICATION (5 minutes)

### 3.1 Enable Google Sign-In
1. Firebase Console → Authentication
2. Click "Get started" (if first time)
3. Click "Google" provider
4. Enable toggle
5. Project support email: Select your email
6. Click "Save"

### 3.2 Add Test Users (Optional but Recommended)
1. Still in Authentication
2. Click "Users" tab
3. Click "Add user"
4. Email: test@example.com
5. Password: TestPassword123
6. Click "Add user"

---

## ☁️ STEP 4: GOOGLE CLOUD SETUP (15 minutes)

### 4.1 Enable YouTube Data API
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your Firebase project
3. Search for "YouTube Data API v3"
4. Click on it
5. Click "Enable"
6. Wait for activation

### 4.2 Enable Google Drive API
1. In Google Cloud Console
2. Search for "Google Drive API"
3. Click on it
4. Click "Enable"
5. Wait for activation

### 4.3 Create API Key
1. Google Cloud Console → APIs & Services → Credentials
2. Click "Create Credentials" → "API Key"
3. Copy the API key
4. Click "Edit API key" (pencil icon)
5. Restrict key:
   - Application restrictions: Android/iOS apps
   - API restrictions: Select YouTube Data API v3
6. Save

### 4.4 Create OAuth Credentials (Android)
1. Credentials → Create Credentials → OAuth client ID
2. Application type: Android
3. Add fingerprint:
   ```bash
   # Run this command to get SHA-1 fingerprint
   keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
4. Copy the SHA-1 value
5. Paste in "SHA-1 certificate fingerprints"
6. Create OAuth client
7. Copy Client ID

### 4.5 Create OAuth Credentials (iOS)
1. Credentials → Create Credentials → OAuth client ID
2. Application type: iOS
3. Bundle ID: com.example.mediaGalleryApp
4. Create OAuth client
5. Copy Client ID

---

## 📝 STEP 5: UPDATE APP CONFIGURATION (10 minutes)

### 5.1 Update firebase_options.dart
Edit `lib/firebase_options.dart` and replace:

```dart
// Android credentials
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'media-gallery-app',
  storageBucket: 'media-gallery-app.appspot.com',
);

// iOS credentials  
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'media-gallery-app',
  storageBucket: 'media-gallery-app.appspot.com',
  iosBundleId: 'com.example.mediaGalleryApp',
);
```

**Get values from:**
1. Firebase Console → Project Settings → General
2. Scroll down to find apiKey, appId, etc.
3. Copy and paste into firebase_options.dart

### 5.2 Update pubspec.yaml
Verify YouTube API key:
```yaml
# Add to pubspec.yaml if not present
# google_maps_flutter: ^2.0.0  # Or YouTube key elsewhere
```

### 5.3 Android Configuration
Edit `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.example.media_gallery_app"
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 5.4 iOS Configuration
Edit `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to photos for uploading to gallery</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSLocalNetworkUsageDescription</key>
<string>We need local network access</string>
<key>NSBonjourServiceTypes</key>
<array>
    <string>_http._tcp</string>
</array>
```

---

## ✅ STEP 6: TEST LOCALLY (10 minutes)

### 6.1 Run on Android Emulator
```bash
# Navigate to project
cd c:\Users\karti\OneDrive\Desktop\App\media_gallery_app

# Get dependencies
flutter pub get

# Run app
flutter run -d android
```

### 6.2 Run on iOS Simulator (macOS only)
```bash
flutter run -d ios
```

### 6.3 Verify Features
- [ ] App launches without errors
- [ ] All 3 tabs visible
- [ ] "Sign In" button visible
- [ ] Click Sign In → Google dialog appears
- [ ] Sign in with test account
- [ ] Home screen shows sample photo
- [ ] Videos screen shows sample video
- [ ] Info screen displays correctly

---

## 🚀 STEP 7: BUILD FOR ANDROID (30 minutes)

### 7.1 Create Signing Key
```bash
# Run in PowerShell as Administrator
keytool -genkey -v -keystore $HOME/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload

# When prompted:
# Keystore password: create-a-strong-password
# Key password: same-as-above
# Name: Your Name
# Organization: Your Company
# City: Your City
# State: Your State
# Country: US
```

### 7.2 Create key.properties
Create file: `android/key.properties`
```
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=upload
storeFile=/Users/your-username/upload-keystore.jks
```

### 7.3 Update build.gradle
Edit `android/app/build.gradle`, add before `android {`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 7.4 Build AAB
```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 🍎 STEP 8: BUILD FOR iOS (30 minutes - macOS only)

### 8.1 Update Version
Edit `ios/Runner.xcconfig`:
```
MARKETING_VERSION = 1.0.0
BUILD_NUMBER = 1
```

### 8.2 Build iOS
```bash
flutter build ios --release
```

### 8.3 Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### 8.4 Configure Signing
1. Select "Runner" project
2. Select "Runner" target
3. General tab → Team: Select your team
4. Signing & Capabilities → Add capability "Sign in with Apple" (optional)

### 8.5 Archive
1. Product → Archive
2. Wait for build to complete
3. Archive appears in Organizer

---

## 📱 STEP 9: SUBMIT TO GOOGLE PLAY STORE

### 9.1 Create Developer Account
1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Sign In"
3. Create account if needed
4. Pay $25 developer fee
5. Complete merchant account setup

### 9.2 Create App
1. Click "Create app"
2. App name: "Media Gallery"
3. Default language: English
4. App or game: App
5. Category: Photography
6. Free: Yes
7. Click "Create app"

### 9.3 Fill Store Listing
1. App → Store listing
2. Short description (80 chars): "Share and manage photos and videos"
3. Full description: Copy from README.md
4. Screenshots: Add at least 2 (800x600)
5. Feature graphic: 1024x500
6. Icon: 512x512
7. Click "Save"

### 9.4 Upload AAB
1. Testing → Internal testing
2. Click "Create new release"
3. Click "Upload" and select AAB file
4. Click "Review"
5. Click "Publish"

### 9.5 Wait for Review
- Keep checking status
- Usually approved within 24 hours
- May need to fix issues if rejected

---

## 🎯 STEP 10: SUBMIT TO APP STORE

### 10.1 Create Apple Developer Account
1. Go to [Apple Developer](https://developer.apple.com)
2. Click "Sign Up"
3. Enroll in Developer Program ($99/year)
4. Accept agreements
5. Set up payment

### 10.2 Create App in App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps"
3. Click "+"
4. Select "New App"
5. Platform: iOS
6. Name: "Media Gallery"
7. SKU: "MediaGallery2026"
8. Bundle ID: com.example.mediaGalleryApp
9. Create

### 10.3 Fill App Information
1. App Information tab
2. Category: Photography
3. Ratings: Complete questionnaire
4. Version Information: 1.0
5. Build: Upload using Xcode

### 10.4 Upload Build
1. In Xcode, open Organizer (Window → Organizer)
2. Select your archive
3. Click "Distribute App"
4. Select "App Store Connect"
5. Automatic signing
6. Upload

### 10.5 Submit for Review
1. Back to App Store Connect
2. Version Release tab
3. Compliance section: Answer all questions
4. Click "Submit for Review"
5. Wait for approval (24-48 hours)

---

## ✅ VERIFICATION CHECKLIST

Before going live:

**Firebase:**
- [ ] Project created
- [ ] Firestore running
- [ ] Collections created
- [ ] Authentication enabled
- [ ] Google Sign-In working
- [ ] Sample data visible

**Configuration:**
- [ ] firebase_options.dart updated
- [ ] Package names correct
- [ ] API keys in place
- [ ] Signing keys created

**Android:**
- [ ] Builds without errors
- [ ] AAB created successfully
- [ ] App uploaded to Play Console
- [ ] Store listing complete

**iOS:**
- [ ] Builds without errors
- [ ] IPA created successfully
- [ ] App submitted to App Store
- [ ] Store listing complete

**Testing:**
- [ ] App runs on real device
- [ ] Sign-in works
- [ ] Photos load
- [ ] Videos play
- [ ] No crashes

---

## 🎉 THAT'S IT!

Your app is now deployed to both stores. Celebrate! 🚀

**Timeline:**
- Firebase setup: 30 mins
- Local testing: 10 mins
- Android build & upload: 1-2 hours
- iOS build & upload: 1-2 hours
- Google Play approval: 24 hours
- App Store approval: 24-48 hours
- **Total time to live: 2-4 days**

**Share with your users once approved!**
