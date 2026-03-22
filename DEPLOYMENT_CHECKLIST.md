# DEPLOYMENT CHECKLIST - STEP BY STEP

## Phase 1: Local Development (Today)

### Step 1.1: Verify Flutter Installation
- [ ] Flutter SDK installed
- [ ] Android Studio/Xcode available
- [ ] Device/Emulator ready
- [ ] Run `flutter doctor` - all green checkmarks

### Step 1.2: Project Setup
- [ ] Navigate to project folder
- [ ] Run `flutter pub get`
- [ ] No dependency errors
- [ ] All packages downloaded

### Step 1.3: Configure Firebase
- [ ] Firebase project created
- [ ] `flutterfire configure` executed
- [ ] Firebase credentials in `firebase_options.dart`
- [ ] Test Firebase connection

### Step 1.4: Local Testing
- [ ] App runs without errors
- [ ] All 3 screens display correctly
- [ ] Navigation works smoothly
- [ ] Sign-in button visible

---

## Phase 2: Firebase Setup (30 mins)

### Step 2.1: Firestore Database
- [ ] Firestore created in Firebase Console
- [ ] `photos` collection created
- [ ] `videos` collection created
- [ ] `admins` collection created
- [ ] Test document added to each collection

### Step 2.2: Authentication
- [ ] Google Sign-In enabled
- [ ] OAuth consent screen configured
- [ ] Test users added (if needed)
- [ ] Sign-in tested on device

### Step 2.3: Security Rules (Test Mode First)
- [ ] Firestore rules updated to test mode
- [ ] Users can read but not write
- [ ] Test sign-in and read access

### Step 2.4: Add Admin User
- [ ] Create admin document in `admins` collection
- [ ] Add your email as admin
- [ ] Verify admin access works

---

## Phase 3: Android Release (1-2 hours)

### Step 3.1: Prepare Android Build
- [ ] Update `pubspec.yaml` version
- [ ] Update Android package name: `com.example.media_gallery_app`
- [ ] Update app name in `android/app/src/main/AndroidManifest.xml`
- [ ] Update `android/app/build.gradle` with signing config

### Step 3.2: Create Signing Key
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload
```
- [ ] Key created and saved securely
- [ ] Password saved in safe location
- [ ] Fingerprint obtained for Google Cloud

### Step 3.3: Build AAB
```bash
flutter build appbundle --release
```
- [ ] Build successful
- [ ] AAB file generated: `build/app/outputs/bundle/release/app-release.aab`
- [ ] File size reasonable (~50-100 MB)

### Step 3.4: Google Play Console Setup
- [ ] Developer account created ($25 paid)
- [ ] Merchant account linked
- [ ] Create new app in Play Console
- [ ] Fill store listing (screenshots, description)
- [ ] Add app icon (512x512 px)
- [ ] Set content rating

### Step 3.5: Upload to Play Store
- [ ] Upload AAB to Play Console
- [ ] Review permissions (Camera, Photos)
- [ ] Add privacy policy URL
- [ ] Add terms of service URL
- [ ] Set release notes
- [ ] Submit for review

**Expected Review Time: 24-48 hours**

---

## Phase 4: iOS Release (2-3 hours)

### Step 4.1: Prepare iOS Build
- [ ] Update version in `pubspec.yaml`
- [ ] Update Bundle ID: `com.example.mediaGalleryApp`
- [ ] Update iOS deployment target to 12.0
- [ ] Add permissions to `ios/Runner/Info.plist`

### Step 4.2: Create iOS Signing Certificate
**Via Apple Developer Console:**
- [ ] Create iOS Distribution Certificate
- [ ] Create App ID: `com.example.mediaGalleryApp`
- [ ] Create Distribution Provisioning Profile
- [ ] Download all certificates to Xcode

### Step 4.3: Build for iOS
```bash
flutter build ios --release
```
- [ ] Build successful
- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Select Team in signing
- [ ] Update version/build number

### Step 4.4: Create Archive
**In Xcode:**
- [ ] Select Generic iOS Device
- [ ] Product → Archive
- [ ] Archive window opens
- [ ] Archive created successfully

### Step 4.5: Upload to App Store
**In Xcode Organizer:**
- [ ] Click "Distribute App"
- [ ] Select "App Store Connect"
- [ ] Automatic code signing
- [ ] Upload to App Store

**Or use Transporter:**
```bash
xcrun altool --upload-app -f app.ipa -t ios -u your@email.com -p app-specific-password
```

### Step 4.6: App Store Connect Setup
- [ ] Create new app in App Store Connect
- [ ] Bundle ID: `com.example.mediaGalleryApp`
- [ ] Fill app information
- [ ] Add app icon (1024x1024 px)
- [ ] Add screenshots (at least 2)
- [ ] Set category: Photography
- [ ] Add privacy policy URL
- [ ] Complete rights and certifications

### Step 4.7: Submit for Review
- [ ] Version ready for review
- [ ] Content rating completed
- [ ] All required fields filled
- [ ] Submit for App Review

**Expected Review Time: 24-48 hours**

---

## Phase 5: Post-Launch (After Approval)

### Step 5.1: Monitoring
- [ ] Enable Firebase Analytics
- [ ] Enable Crashlytics
- [ ] Set up performance monitoring
- [ ] Configure remote config

### Step 5.2: User Feedback
- [ ] Monitor app store reviews
- [ ] Respond to user feedback
- [ ] Track crash reports
- [ ] Monitor performance metrics

### Step 5.3: Update Security Rules
- [ ] Change Firestore rules to production
- [ ] Implement proper access control
- [ ] Add rate limiting if needed
- [ ] Enable backups

### Step 5.4: Admin Setup
- [ ] Document admin upload process
- [ ] Create YouTube playlist links
- [ ] Add initial photos to Google Drive
- [ ] Test real-time sync
- [ ] Document video year organization

---

## Quick Commands Reference

```bash
# Check Flutter setup
flutter doctor

# Get dependencies
flutter pub get

# Run app
flutter run

# Build Android AAB
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Get Firebase config
flutterfire configure

# Generate Android signing key
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload

# View app signing info
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

---

## Important URLs

| Task | URL |
|------|-----|
| Firebase Console | https://console.firebase.google.com |
| Google Play Console | https://play.google.com/console |
| App Store Connect | https://appstoreconnect.apple.com |
| Google Cloud Console | https://console.cloud.google.com |
| Flutter Docs | https://flutter.dev/docs |
| Firebase Docs | https://firebase.google.com/docs |

---

## Critical Passwords & Keys (Keep Safe)

⚠️ **Never commit these to Git:**
- Firebase credentials
- Google API keys
- App signing keys
- Android keystore password
- Apple certificates

**Store in secure location:**
- Password manager
- Encrypted drive
- Company vault

---

## Troubleshooting Guide

### Issue: "No devices available"
**Solution:**
- Connect Android device or start emulator
- Run `flutter devices` to verify
- Check USB debugging enabled

### Issue: Firebase connection error
**Solution:**
- Verify firebase_options.dart
- Check internet connection
- Regenerate Firebase config: `flutterfire configure`

### Issue: Image not loading
**Solution:**
- Verify image URL is public
- Check Firestore rules allow read
- Test in browser first

### Issue: YouTube video won't play
**Solution:**
- Verify YouTube URL format
- Check YouTube API key
- Ensure API is enabled in Google Cloud

### Issue: Google Play Store rejection
**Solution:**
- Read rejection email carefully
- Fix privacy policy links
- Ensure permissions justified
- Resubmit

### Issue: App Store rejection
**Solution:**
- Review App Store guidelines
- Check for policy violations
- Remove test accounts/links
- Resubmit with explanation

---

## Success Indicators ✅

After completing all phases, you should have:

- ✅ App available on Google Play Store
- ✅ App available on Apple App Store
- ✅ Real-time photo sync working
- ✅ YouTube videos displaying correctly
- ✅ Admin upload functionality working
- ✅ User authentication functional
- ✅ Firebase monitoring active
- ✅ Security rules in production
- ✅ Privacy policy & terms accessible
- ✅ Support contact information available

---

## Timeline Estimate

| Phase | Estimated Time |
|-------|-----------------|
| Phase 1: Local Dev | 30 mins |
| Phase 2: Firebase | 30 mins |
| Phase 3: Android | 1-2 hours |
| Phase 4: iOS | 2-3 hours |
| Play Store Review | 24-48 hours |
| App Store Review | 24-48 hours |
| **TOTAL** | **2-4 hours + 2-4 days review** |

---

**🎉 Congratulations! Your app will be live on both stores!**
