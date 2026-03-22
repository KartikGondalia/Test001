# 🎯 Android APK Testing Guide

## 📦 APK Build Instructions for Your Project

### Quick Build Commands

```bash
# Navigate to project
cd "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app"

# Build debug APK (fastest, for testing)
flutter build apk --debug

# Build release APK (optimized, for production)
flutter build apk --release

# Build split APKs (smaller file sizes)
flutter build apk --release --split-per-abi
```

---

## 📍 Where to Find Your APK

### Debug Build
```
📂 build/app/outputs/apk/debug/
└── app-debug.apk          (45-55 MB)
```

### Release Build
```
📂 build/app/outputs/apk/release/
└── app-release.apk        (35-45 MB)
```

### Split ABIs (Optional)
```
📂 build/app/outputs/apk/release/
├── app-armeabi-v7a-release.apk    (15-20 MB) - 32-bit ARM
├── app-arm64-v8a-release.apk      (20-25 MB) - 64-bit ARM
└── app-x86_64-release.apk         (20-25 MB) - Intel x64
```

---

## 🚀 Installation Methods

### Method 1: ADB (Android Debug Bridge)

```bash
# Connect device via USB or start emulator
adb devices

# Install APK
adb install build/app/outputs/apk/debug/app-debug.apk

# Reinstall (uninstall then install)
adb install -r build/app/outputs/apk/debug/app-debug.apk

# Uninstall
adb uninstall com.example.media_gallery_app
```

### Method 2: Drag & Drop (File Transfer)

1. Connect Android device via USB
2. Enable USB debugging on device
3. Drag APK file to device storage
4. Open Files app on device
5. Tap APK file to install
6. Tap "Install"

### Method 3: Email or Cloud
1. Email APK file to yourself
2. Download on Android device
3. Open Email app
4. Tap attachment
5. Tap "Install"

### Method 4: Local Network (Simpler)
1. Use Syncthing, Nextcloud, or Google Drive
2. Upload APK
3. Download on device
4. Install via Files app

---

## 🧪 Testing Checklist

### Installation Testing
- [ ] APK downloads without errors
- [ ] Installation completes successfully
- [ ] App appears on home screen
- [ ] App icon displays correctly
- [ ] App launches without crash
- [ ] App responds to touches

### Feature Testing
- [ ] Home screen (Photo Gallery) loads
- [ ] Videos screen loads
- [ ] Info screen loads
- [ ] Can switch between tabs
- [ ] All buttons are clickable

### Google Drive Integration Testing
- [ ] Google Sign-In works
- [ ] Photo gallery displays
- [ ] Photos load from Drive folder
- [ ] Refresh button (⟳) functions
- [ ] New photos appear after refresh
- [ ] Photo grid is smooth (60 FPS)

### Video Functionality Testing
- [ ] YouTube videos load
- [ ] Video player displays
- [ ] Can play/pause videos
- [ ] Volume controls work
- [ ] Fullscreen mode works

### Info Screen Testing
- [ ] About section displays
- [ ] Features list visible
- [ ] Support info accessible
- [ ] Legal docs open correctly
- [ ] Share button works

### Error Handling Testing
- [ ] Handle offline (no internet)
- [ ] Handle invalid credentials
- [ ] Handle empty Drive folder
- [ ] Handle API errors gracefully
- [ ] Error messages are clear

### Performance Testing
- [ ] App launches in < 3 seconds
- [ ] Photos display in < 5 seconds
- [ ] Refresh completes in < 10 seconds
- [ ] No memory leaks (long usage)
- [ ] Minimal battery drain
- [ ] Minimal data usage

### Security Testing
- [ ] OAuth tokens handled securely
- [ ] No sensitive data logged
- [ ] No hardcoded credentials
- [ ] Permissions requested properly
- [ ] User data not shared

---

## 🎯 Testing on Different Devices

### Minimum Requirements
- **API Level**: 21+ (Android 5.0)
- **RAM**: 2+ GB
- **Storage**: 100+ MB free
- **Network**: WiFi or 4G/5G

### Recommended Devices
| Device Type | Example | API | Notes |
|-------------|---------|-----|-------|
| Emulator | Android Studio | 28+ | Fast, easier testing |
| Budget Phone | Redmi 9 | 21-24 | Min requirements test |
| Mid-Range | Samsung A50 | 28-31 | Typical user device |
| Flagship | Pixel 6 | 31+ | High-end experience |
| Tablet | iPad Pro | 28+ | Larger screen testing |

---

## 📊 Test Results Recording

### Create Test Log
```
Device: Samsung Galaxy A51
OS Version: Android 12
API Level: 31
RAM: 4GB
Storage: 64GB

Test Results:
✓ App installs successfully
✓ Home screen loads (2.5s)
✓ 5 photos from Drive display
✓ Refresh syncs new photos (7s)
✓ Video page loads (1.5s)
✓ Info page displays correctly
✓ No crashes detected
✓ No permission errors
✓ Offline handling works
✓ Error messages clear

Overall: PASS ✓
Date: March 22, 2026
Tester: [Your Name]
```

---

## 🐛 Common Issues & Solutions

### App Crashes on Launch
```
✓ Solution: Clear app data
Settings → Apps → Media Gallery → Storage → Clear Data

✓ Solution: Check API compatibility
Ensure device Android version ≥ 5.0 (API 21)

✓ Solution: Reinstall APK
adb uninstall com.example.media_gallery_app
adb install app-debug.apk
```

### Photos Not Displaying
```
✓ Check: Internet connection
Settings → WiFi → Verify connected

✓ Check: Google Sign-In
Sign out and sign back in

✓ Check: Drive folder ID
Verify folder contains images

✓ Check: Firestore rules
Ensure read permission for authenticated users
```

### Videos Won't Load
```
✓ Check: YouTube API enabled
Verify in Google Cloud Console

✓ Check: YouTube URLs configured
Check Firestore videos collection

✓ Check: Video IDs valid
Test URLs in browser first
```

### Google Sign-In Fails
```
✓ Check: OAuth credentials
Verify Android SHA-1 fingerprint in Firebase

✓ Solution: Get SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore

✓ Solution: Add to Firebase
Firebase Console → Settings → Add SHA-1
```

### Slow Performance
```
✓ Solution: Clear cache
Settings → Apps → Media Gallery → Storage → Clear Cache

✓ Solution: Update app
Rebuild with latest code

✓ Check: Device resources
Close other apps, free up RAM

✓ Check: Network speed
Test with WiFi instead of mobile
```

---

## 📈 Performance Metrics

Measure these during testing:

| Metric | Target | Acceptable |
|--------|--------|------------|
| App Launch Time | < 2s | < 3s |
| Photo Load Time | < 2s | < 5s |
| Refresh Sync Time | < 8s | < 10s |
| Memory Usage | < 100MB | < 150MB |
| Battery Drain (1hr) | < 3% | < 5% |
| Data Usage (sync) | < 1MB | < 2MB |
| Frame Rate | 60 FPS | > 30 FPS |

---

## 🔍 Debug Tools

### Android Studio Logcat
```
1. Open Android Studio
2. Connect device
3. View → Tool Windows → Logcat
4. Filter for "media_gallery" or "Flutter"
5. Watch for errors and warnings
```

### ADB Commands for Debugging
```bash
# View logs
adb logcat | grep flutter

# Get device info
adb shell getprop ro.build.version.android

# Install with debug logging
adb install -r app-debug.apk
adb logcat

# Record screen
adb shell screenrecord /sdcard/test.mp4

# Pull test video
adb pull /sdcard/test.mp4
```

### Firebase Console Monitoring
```
1. Firebase Console
2. Select Project
3. Analytics → Dashboard
4. Monitor events and crashes
5. Check Firestore usage
```

---

## ✅ Pre-Release Testing Checklist

### Functional Testing
- [ ] All 3 screens work
- [ ] Navigation between screens smooth
- [ ] Google Sign-In functional
- [ ] Photos display from Drive
- [ ] Refresh button works
- [ ] Admin instructions show
- [ ] Videos play
- [ ] Info page accessible

### Compatibility Testing
- [ ] Works on API 21
- [ ] Works on API 28
- [ ] Works on API 31+
- [ ] Works on various screen sizes
- [ ] Works on tablets
- [ ] Works on different manufacturers

### Security Testing
- [ ] OAuth tokens secure
- [ ] No data stored unencrypted
- [ ] Permissions justified
- [ ] No crashes reveal data
- [ ] Network traffic encrypted

### Performance Testing
- [ ] App launches quickly
- [ ] No memory leaks
- [ ] Smooth scrolling
- [ ] Fast photo loading
- [ ] Low battery impact

### User Experience Testing
- [ ] Clear error messages
- [ ] Intuitive UI
- [ ] Responsive buttons
- [ ] Proper loading indicators
- [ ] Good visual design

### Analytics Testing
- [ ] Event tracking works
- [ ] Crash reporting works
- [ ] Session tracking works
- [ ] User properties logged

---

## 📤 Sharing Test APK

### With Testers
```
Option 1: Email
- Send APK file directly
- Include APK_BUILD_INSTRUCTIONS.md
- Request feedback

Option 2: Google Drive
- Upload APK to shared folder
- Share link
- Include testing checklist

Option 3: Firebase App Distribution
- Firebase Console → App Distribution
- Upload APK
- Invite testers
- Track feedback
```

### APK Distribution Steps
1. Upload APK to hosting (Google Drive, OneDrive, etc.)
2. Create shared link
3. Send to testers with instructions
4. Collect feedback
5. Fix issues
6. Build new APK
7. Repeat until ready

---

## 🎯 Final Testing Before Release

### Comprehensive Testing
- [ ] Functional testing complete
- [ ] Performance acceptable
- [ ] No critical bugs
- [ ] All features working
- [ ] Approved by QA

### Store Listing Ready
- [ ] Screenshots captured
- [ ] App description written
- [ ] Keywords defined
- [ ] Category selected
- [ ] Content rating set

### Release Build Ready
- [ ] Signed APK created
- [ ] Version code updated
- [ ] Version name set
- [ ] Build tested
- [ ] Ready for upload

### Documentation Complete
- [ ] Setup guide final
- [ ] User manual written
- [ ] Privacy policy updated
- [ ] Terms of service ready
- [ ] Release notes prepared

---

## 📞 Feedback & Iteration

### Collect Feedback
- Ask testers: "Does it work?"
- Check: Do features function?
- Monitor: Any crashes?
- Measure: Performance good?
- Assess: User happy?

### Common Feedback
- "Photos won't load" → Check Drive folder
- "App crashes" → Check API compatibility
- "Too slow" → Optimize, clear cache
- "Confusing UI" → Add instructions
- "Battery drain" → Optimize syncing

### Fix & Rebuild
1. Note feedback
2. Fix issues
3. Rebuild APK
4. Retest
5. Get approval
6. Deploy new version

---

## 🚀 Ready for Release Checklist

- [ ] All testing complete
- [ ] No known critical bugs
- [ ] Performance acceptable
- [ ] User feedback positive
- [ ] APK signed and optimized
- [ ] Store listing ready
- [ ] Privacy policy updated
- [ ] Screenshots prepared
- [ ] Release notes written

**Status**: Ready for Play Store Submission ✓

---

**Last Updated**: March 22, 2026  
**Version**: 1.0  
**Status**: Ready for Testing
